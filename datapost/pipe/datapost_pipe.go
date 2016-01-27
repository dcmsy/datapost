/*
* 数据管道，完成读取配置文件，从源库到目的库数据传输功能
 */
package pipe

import (
	"bytes"
	"encoding/xml"
	"fmt"
	"github.com/donnie4w/go-logger/logger"
	_ "github.com/go-sql-driver/mysql"
	"github.com/jakecoffman/cron"
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
	"io/ioutil"
	"strconv"
	"strings"
	"time"
)

var (
	StartFlag bool = false
	ConfigMap map[string]string
	SysMap    map[string]string
	SysArr    []string
)

/*初始化config参数*/
func InitConfigMap() {
	ConfigMap = ReadIniFile("config/config.ini", "config")
	//解析site
	SysMap = make(map[string]string)
	SysArr = strings.Split(ConfigMap["sites"], ",")
	for i := range SysArr {
		itemes := strings.Split(SysArr[i], "|")
		if len(itemes) == 4 {
			SysMap[itemes[0]] = SysArr[i]
		}
	}
}

/*读取db配置文件信息 初始化dbini文件*/
func InitDBini(dirName string) DBini {
	var dbini DBini
	var buffer bytes.Buffer
	buffer.WriteString("xml")
	buffer.WriteString("/")
	buffer.WriteString(dirName)
	buffer.WriteString("/")
	buffer.WriteString(dirName)
	buffer.WriteString(".ini")
	dbMap := GetIni(dirName, buffer.String(), "dbconfig")
	dbini.F_DbType = dbMap["f_dbtype"]
	dbini.T_DbType = dbMap["t_dbtype"]

	dbini.F_Driver = dbMap["f_driver"]
	dbini.F_Dburl = dbMap["f_dburl"]
	dbini.F_Ip = dbMap["f_ip"]
	dbini.F_Port = dbMap["f_port"]
	dbini.F_Dbname = dbMap["f_dbname"]
	dbini.F_User = dbMap["f_user"]
	dbini.F_Password = dbMap["f_password"]

	dbini.T_Driver = dbMap["t_driver"]
	dbini.T_Dburl = dbMap["t_dburl"]
	dbini.T_Ip = dbMap["t_ip"]
	dbini.T_Port = dbMap["t_port"]
	dbini.T_Dbname = dbMap["t_dbname"]
	dbini.T_User = dbMap["t_user"]
	dbini.T_Password = dbMap["t_password"]

	dbini.SysId = dbMap["sysid"]
	dbini.SysType = dbMap["systype"]
	dbini.SysName = dbMap["sysname"]
	dbini.Company = dbMap["company"]
	dbini.Platform = dbMap["platform"]
	return dbini
}

/*读取db配置文件信息 初始化dbini文件*/
func InitConfigInfo() ConfigInfo {
	var configInfo ConfigInfo
	configInfo.singletimer = ConfigMap["singletimer"]
	configInfo.repeatetimer = ConfigMap["repeatetimer"]
	configInfo.sites = ConfigMap["sites"]
	configInfo.transferes = ConfigMap["transferes"]
	configInfo.nosql = ConfigMap["nosql"]

	return configInfo
}

/*读取xml信息初始化xmlinfo*/
func InitXmlInfo(dirName string) XmlInfo {
	content, err := ioutil.ReadFile("xml/HostAudit/repeatetimer_主机审计日志.xml")
	if err != nil {
		logger.Error(err)
	}
	var result XmlInfo
	err = xml.Unmarshal(content, &result)
	if err != nil {
		logger.Error(err)
	}
	return result
}

/*读取xml信息 初始化xmlinfo*/
func InitXmlInfoes(dirName string, filter string) []XmlInfo {
	fileNames := GetXmlFileNames(dirName, filter)
	var values = make([]XmlInfo, len(fileNames))
	var i = 0
	for _, v := range fileNames {
		content, err := ioutil.ReadFile(v)
		if err != nil {
			logger.Error(err)
		}
		var result XmlInfo
		err = xml.Unmarshal(content, &result)
		if err != nil {
			logger.Error(err)
		}
		values[i] = result
		values[i].CheckFlag = true
		i++
	}
	return values
}

/*初始化SysIni*/
func InitSysIni(dirName string) SysIni {
	var sysIni SysIni
	sysIni.configInfo = InitConfigInfo()
	sysIni.dbini = InitDBini(dirName)
	sysIni.xmlInfo = InitXmlInfo(dirName)
	sysIni.xmlInfoes = InitXmlInfoes(dirName, "repeatetimer")
	sysIni.singleXmlInfoes = InitXmlInfoes(dirName, "singletimer")
	return sysIni
}

/*接口*/
type Pipe interface {
	Alter(dbIni *DBini, xmlInfo *XmlInfo)    //判断是否需要添加标记位，如需要添加标记位
	Check(dbIni *DBini, xmlInfo *XmlInfo)    //判断是否需要查询数据
	Reader(dbIni *DBini, xmlInfo *XmlInfo)   //读取源数据库
	Writer(dbIni *DBini, xmlInfo *XmlInfo)   //写入目标库数据
	Updater(dbIni *DBini, xmlInfo *XmlInfo)  //更新源库标记位
	DataPipe(dbIni *DBini, xmlInfo *XmlInfo) //边读边写边更新 节省服务器内存开销
}

/*判断是否需要添加标记位，如需要添加标记位*/
func Alter(dbIni *DBini, xmlInfo *XmlInfo) {
	if len(xmlInfo.CheckColumnSQL) > 0 {
		defer func() {
			if err := recover(); err != nil {
				logger.Error("数据库执行失败", err)
			}
		}()
		f_pwd, _ := Base64Dec(dbIni.F_Password)
		dbIni.F_Db.Db_open(dbIni.F_DbType, dbIni.F_User, f_pwd, dbIni.F_Ip, dbIni.F_Port, dbIni.F_Dbname)
		defer dbIni.F_Db.db.Close()

		if dbIni.F_Db.db == nil {
			logger.Error("数据库连接异常")
			panic("数据库连接异常")
			return
		}
		testQuery, err := dbIni.F_Db.db.Query("select 1")
		if err != nil {
			logger.Error("数据库连接异常,无法查询测试数据", err.Error())
			panic(err.Error())
			return
		} else {
			if !testQuery.Next() {
				logger.Error("数据库连接异常,无法遍历测试数据")
				panic(err.Error())
				return
			}
			defer testQuery.Close()
		}
		query, err := dbIni.F_Db.db.Query(strings.Replace(xmlInfo.CheckColumnSQL, "@[dbname]", dbIni.F_Dbname, -1)) //查询数据库
		defer query.Close()
		if err != nil {
			logger.Error("查询数据库失败", err.Error())
			panic(err)
			return
		}
		if query.Next() {
			logger.Info(xmlInfo.Remark, "经检测，标记位已添加")
			xmlInfo.AlterFlag = true
		} else {
			stmt, err := dbIni.F_Db.db.Prepare(xmlInfo.AlterSQL)
			defer stmt.Close()
			if err != nil {
				logger.Error(err)
				return
			}
			stmt.Exec()
			logger.Info(xmlInfo.Remark, "在源数据库中添加成功")
			updateStmt, err := dbIni.F_Db.db.Prepare(xmlInfo.UpdateFlagSQL)
			defer updateStmt.Close()
			if err != nil {
				logger.Error(err)
				return
			}
			updateStmt.Exec()
			logger.Info(xmlInfo.Remark, "在源数据库中更新成功")
			xmlInfo.AlterFlag = true
		}
	} else {
		logger.Info(xmlInfo.Remark, "无需检测标记位")
		xmlInfo.AlterFlag = true
	}
}

/*判断是否需要查询数据*/
func Check(dbIni *DBini, xmlInfo *XmlInfo) {
	if strings.EqualFold(xmlInfo.IsValData, "true") {
		xmlInfo.CheckFlag = true
		return
	}
	if len(xmlInfo.CheckRowSQL) > 0 {
		defer func() {
			if err := recover(); err != nil {
				logger.Error("查询数据库失败", err)
			}
		}()
		f_pwd, _ := Base64Dec(dbIni.F_Password)
		dbIni.F_Db.Db_open(dbIni.F_DbType, dbIni.F_User, f_pwd, dbIni.F_Ip, dbIni.F_Port, dbIni.F_Dbname)
		defer dbIni.F_Db.db.Close()
		query, err := dbIni.F_Db.db.Query(strings.Replace(xmlInfo.CheckRowSQL, "@[dbname]", dbIni.F_Dbname, -1)) //查询数据库
		defer query.Close()

		if err != nil {
			logger.Error("查询数据库失败", err.Error())
			xmlInfo.CheckFlag = false
			panic(err)
			return
		}
		cols, _ := query.Columns()
		values := make([][]byte, len(cols))     //values是每个列的值
		scans := make([]interface{}, len(cols)) //query.Scan的参数 用len(cols)定住当次查询的长度
		for i := range values {                 //让每一行数据都填充到[][]byte里面
			scans[i] = &values[i]
		}
		dbRows := 0
		if query.Next() {
			//判断是否与上次的数据一致，如果不一致则查询数据库，否则不查询
			if err := query.Scan(scans...); err != nil { //query.Scan查询出来的不定长值放到scans[i] = &values[i],也就是每行都放在values里
				logger.Error(err)
				xmlInfo.CheckFlag = false
				return
			}
			for _, v := range values {
				intV, err := strconv.Atoi(string(v))
				if err != nil {
					xmlInfo.CheckFlag = false
				} else {
					dbRows = intV
				}
			}
			if dbRows != 0 && dbRows != xmlInfo.RowNum { //获取reader 如何获取到数据则置为0，如果获取不到了则赋予全局GobalNum
				xmlInfo.RowNum = dbRows
				xmlInfo.GobalNum = dbRows
				xmlInfo.CheckFlag = true
			} else {
				xmlInfo.CheckFlag = false
			}
		} else {
			xmlInfo.CheckFlag = true
		}
	} else {
		logger.Info(xmlInfo.Remark, "无需查询系统库行记录是否变化")
		xmlInfo.CheckFlag = true
	}
}

/*访问数据库获取数据*/
func Reader(dbIni *DBini, xmlInfo *XmlInfo) {
	logger.Info("***************************")
	logger.Info("Reader begin >>>>>>>>>>>>>>>>")
	query, err := dbIni.F_Db.db.Query(xmlInfo.DataSQL) //查询数据库
	if err != nil {
		logger.Error("查询数据库失败", err.Error())
		return
	}
	defer query.Close()
	cols, _ := query.Columns()
	values := make([][]byte, len(cols))     //values是每个列的值
	scans := make([]interface{}, len(cols)) //query.Scan的参数 用len(cols)定住当次查询的长度
	for i := range values {                 //让每一行数据都填充到[][]byte里面
		scans[i] = &values[i]
	}
	results := make(map[int]map[string]string) //最后得到的map
	i := 0
	for query.Next() { //循环
		if err := query.Scan(scans...); err != nil { //query.Scan查询出来的不定长值放到scans[i] = &values[i],也就是每行都放在values里
			logger.Error(err)
			return
		}
		row := make(map[string]string) //每行数据
		for k, v := range values {
			key := cols[k]
			row[key] = string(v)
		}
		results[i] = row //装入结果集中
		i++
	}
	if i == 0 {
		xmlInfo.RowNum = xmlInfo.GobalNum
	} else {
		xmlInfo.RowNum = 0
	}
	xmlInfo.Datas = results
	xmlInfo.Columns = cols
	logger.Info("Reader end >>>>>>>>>>>>>>>>")
}

/*将数据写入数据库*/
func Writer(dbIni *DBini, xmlInfo *XmlInfo) {
	logger.Info("***************************")
	logger.Info("Writer begin >>>>>>>>>>>>>>>>")
	if len(xmlInfo.Datas) == 0 {
		logger.Info("Writer end >>>>>>>>>>>>>>>>")
		return
	}
	stmt, err := dbIni.T_Db.db.Prepare(xmlInfo.InsertSQL)
	defer stmt.Close()
	if err != nil {
		logger.Error(err)
		return
	}
	colsLength := len(xmlInfo.Columns)
	c := 0
	arrIds := make([]string, len(xmlInfo.Datas))
	for _, v := range xmlInfo.Datas {
		scans := make([]interface{}, colsLength+2)
		for i := range xmlInfo.Columns {
			scans[i] = v[xmlInfo.Columns[i]]
		}
		scans[colsLength] = dbIni.SysId
		scans[colsLength+1] = dbIni.SysName
		arrIds[c] = v[xmlInfo.Columns[0]]
		stmt.Exec(scans...)
		c++
	}
	xmlInfo.Datas = nil
	xmlInfo.Ids = arrIds
	logger.Info("Writer end >>>>>>>>>>>>>>>>")
}

/*回写标记位*/
func Updater(dbIni *DBini, xmlInfo *XmlInfo) {
	logger.Info("***************************")
	logger.Info("Updater begin >>>>>>>>>>>>>>>>")
	defer func() {
		if err := recover(); err != nil {
			logger.Error("数据库执行失败", err)
		}
	}()
	if len(xmlInfo.SuccessSQL) > 0 {
		var buffer bytes.Buffer
		idsLength := len(xmlInfo.Ids)
		idsLength--
		for i := range xmlInfo.Ids {
			if i == idsLength {
				buffer.WriteString("'")
				buffer.WriteString(xmlInfo.Ids[i])
				buffer.WriteString("'")
			} else {
				buffer.WriteString("'")
				buffer.WriteString(xmlInfo.Ids[i])
				buffer.WriteString("',")
			}
		}
		if len(buffer.String()) > 0 {
			stmt, err := dbIni.F_Db.db.Prepare(strings.Replace(xmlInfo.SuccessSQL, "@[id]", buffer.String(), -1))
			defer stmt.Close()
			if err != nil {
				logger.Error(err)
				panic(err)
				return
			}
			stmt.Exec()
		}
	}
	logger.Info("Updater end >>>>>>>>>>>>>>>>")
}

/*边读边写边更新 节省服务器内存开销*/
func DataPipe(dbIni *DBini, xmlInfo *XmlInfo) {
	logger.Info("***************************")
	logger.Info("Reader begin >>>>>>>>>>>>>>>>")
	defer func() {
		if err := recover(); err != nil {
			logger.Error("数据库执行失败", err)
		}
	}()
	query, err := dbIni.F_Db.db.Query(xmlInfo.DataSQL) //查询数据库
	if err != nil {
		logger.Error("查询数据库失败", err.Error())
		panic(err)
		return
	}
	defer query.Close()
	//insert
	stmt, err := dbIni.T_Db.db.Prepare(xmlInfo.InsertSQL)
	defer stmt.Close()
	if err != nil {
		logger.Error(err)
		panic(err)
		return
	}

	cols, _ := query.Columns()
	colsLength := len(cols)
	values := make([][]byte, colsLength)
	scans := make([]interface{}, colsLength)
	for i := range values {
		scans[i] = &values[i]
	}
	results := make(map[int]map[string]string)
	idsMap := make(map[int]string)
	i := 0
	for query.Next() { //循环
		if err := query.Scan(scans...); err != nil {
			logger.Error(err)
			return
		}
		row := make(map[string]string) //每行数据
		for k, v := range values {
			key := cols[k]
			row[key] = string(v)
		}
		results[i] = row //装入结果集中
		wscans := make([]interface{}, colsLength+2)
		for j := range cols {
			wscans[j] = row[cols[j]]
		}
		wscans[colsLength] = dbIni.SysId
		wscans[colsLength+1] = dbIni.SysName
		r, err := stmt.Exec(wscans...)
		if err != nil {
			logger.Error("#datapost_pipe装入结果集中,执行insert:", xmlInfo.FileName, r, err)
		}
		idsMap[i] = row[cols[0]]
		i++
	}
	//判断是否有数据
	if i == 0 {
		xmlInfo.NotExistData = true
	} else {
		xmlInfo.NotExistData = false
	}
	mapLength := len(idsMap)
	if mapLength > 0 {
		arrIds := make([]string, mapLength)
		for k, v := range idsMap {
			arrIds[k] = v
		}
		xmlInfo.Ids = arrIds
	}
	idsMap = nil
	logger.Info("Reader end >>>>>>>>>>>>>>>>")
}

/*启动所有配置信息*/
func StartAllSys() {
	StartFlag = true
	dirs := strings.Split(ConfigMap["transferes"], ",")
	nosqlDir := ConfigMap["nosql"]
	//nosql目录
	if len(nosqlDir) > 0 {
		go GetSysIni(nosqlDir).StartNoSqlSys()
	}
	for i := range dirs {
		if len(dirs[i]) > 0 {
			//非nosql目录
			go GetSysIni(dirs[i]).StartSys()
		}
	}
	for {
		time.Sleep(2 * time.Second)
	}
}

// create SysIni
func GetSysIni(dirName string) *SysIni {
	var sysIni SysIni
	sysIni.configInfo = InitConfigInfo()
	sysIni.dbini = InitDBini(dirName)
	sysIni.xmlInfo = InitXmlInfo(dirName)
	sysIni.xmlInfoes = InitXmlInfoes(dirName, "repeatetimer")
	sysIni.singleXmlInfoes = InitXmlInfoes(dirName, "singletimer")
	return &sysIni
}

/*启动*/
func (sys *SysIni) StartSys() {
	fmt.Println("SysIni is start................")
	StartFlag = true
	if StartFlag { //判断标记位并增加标记位
		for i := range sys.xmlInfoes {
			Alter(&sys.dbini, &sys.xmlInfoes[i])
			logger.Info("Alter >>>>>>>>>>>>>>>>:", i)
		}
	}
	logger.Info("StartSys >>>>>>>>>>>>>>>>goto for ")
	//单次同步
	c := cron.New()
	c.Start()
	defer c.Stop()
	fmt.Println("singletimer>>>>", sys.configInfo.singletimer)

	//单次同步
	for j := range sys.singleXmlInfoes {
		go func(sys *SysIni, j int) {
			singleXmlInfo := sys.singleXmlInfoes[j]
			c.AddFunc(sys.configInfo.singletimer,
				func() {
					logger.Info("single[", singleXmlInfo.FileName, "] job is run ......................")
					singleXmlInfo.RunSingleDataPipe(&sys.dbini)
				},
				singleXmlInfo.FileName)
		}(sys, j)
	}
	//实时同步
	for StartFlag {
		//边读边写，更新
		for i := range sys.xmlInfoes {
			//logger.Info("sys.xmlInfoes[i].NotExistData >>>>>>>>>>>>>>>>", sys.xmlInfoes[i].Remark, sys.xmlInfoes[i].NotExistData)
			if sys.xmlInfoes[i].NotExistData {
				Check(&sys.dbini, &sys.xmlInfoes[i])
			}
			if sys.xmlInfoes[i].CheckFlag {
				sys.xmlInfoes[i].RunDataPipe(&sys.dbini)
			}
		}
		time.Sleep(2 * time.Second)
	}
}

/*启动*/
func (sys *SysIni) StartNoSqlSys() {
	fmt.Println("StartNoSqlSys is start................")
	//单次同步
	c := cron.New()
	c.Start()
	defer c.Stop()
	for j := range sys.singleXmlInfoes {
		singleXmlInfo := sys.singleXmlInfoes[j]
		c.AddFunc(sys.configInfo.singletimer,
			func() {
				logger.Info("single[", singleXmlInfo.FileName, "] job is run ......................")
				NoSqlSync(&sys.dbini, &sys.singleXmlInfoes[j])
			},
			singleXmlInfo.FileName)
	}
	for {
		time.Sleep(2 * time.Second)
	}
}

func NoSqlSync(dbIni *DBini, xmlInfo *XmlInfo) {
	if !StartFlag {
		return
	}
	defer func() {
		if err := recover(); err != nil {
			logger.Error(err)
		}
	}()
	if strings.EqualFold(xmlInfo.FileName, "network_control") {
		connString := fmt.Sprintf("%s:%s", dbIni.F_Ip, dbIni.F_Port)
		dbName := dbIni.F_Dbname
		yearMonth := GetYearMonth(TimeUtcToStr(time.Now()))
		firstDay := StrToTime(GetMonthFirstDay(TimeUtcToStr(time.Now())))
		siteMap := make(map[int32]Site)
		session, err := mgo.Dial(connString)
		defer session.Close()
		t_pwd, _ := Base64Dec(dbIni.T_Password)
		dbIni.T_Db.Db_open(dbIni.T_DbType, dbIni.T_User, t_pwd, dbIni.T_Ip, dbIni.T_Port, dbIni.T_Dbname)
		//关闭数据库
		defer dbIni.T_Db.db.Close()
		if dbIni.T_Db.db == nil {
			logger.Error("无法链接中间数据库")
			return
		}
		if err != nil {
			logger.Error("无法链接mongodb数据库，请检查配置信息及服务是否正常")
			return
		}
		session.SetMode(mgo.Monotonic, true)
		siteChartTable_c := session.DB(dbName).C("siteChartTable")
		alarmprint_c := session.DB(dbName).C("alarmprint")
		site_c := session.DB(dbName).C("site")

		var siteChartDatas []SiteChartTable
		///////////////////////测试数据 赋值
		//yearMonth = "201406"
		//firstDay = StrToTime(GetMonthFirstDay("2014-06-30 11:13:57"))
		siteChartTable_c.Find(bson.M{"month": yearMonth}).All(&siteChartDatas)

		var alarmDatas []Alarmprint
		alarmprint_c.Find(bson.M{"time": bson.M{"$gte": firstDay}}).All(&alarmDatas)

		var siteDatas []Site
		site_c.Find(nil).All(&siteDatas)

		for i := range siteDatas {
			site := siteDatas[i]
			siteMap[site.Siteurlhash] = site
		}

		fmt.Println("siteChartDatas:", len(siteChartDatas))
		fmt.Println("alarmDatas:", len(alarmDatas))
		fmt.Println("siteDatas:", len(siteDatas))
		//写入中间库
		stmt, err := dbIni.T_Db.db.Prepare(xmlInfo.InsertSQL)
		defer stmt.Close()
		if err != nil {
			panic(err)
			logger.Fatal(err)
			return
		}
		impDate := TimeUtcToStr(time.Now())
		for i := range siteChartDatas {
			siteChart := siteChartDatas[i]
			scans := make([]interface{}, 15)
			month := Substr(siteChart.Month, 4, 2)
			year_month_info := strings.Join([]string{siteChart.Year, month}, "-")
			siteInfo, ok := siteMap[siteChart.Siteurlhash]
			var siteName, siteUrl string
			if ok {
				siteName = siteInfo.Sitename
				siteUrl = siteInfo.Siteurl
			}

			scans[0] = siteInfo.Id.Hex()
			scans[1] = siteName
			scans[2] = siteUrl
			scans[3] = siteChart.Year
			scans[4] = month

			scans[5] = year_month_info
			scans[6] = siteChart.Numwarning
			scans[7] = siteChart.Numsuspicion
			scans[8] = siteChart.Numattention
			scans[9] = 0
			scans[10] = Substr(impDate, 0, 10)
			scans[11] = impDate
			scans[12] = dbIni.SysType
			scans[13] = dbIni.SysId
			scans[14] = dbIni.SysName
			if len(siteInfo.Id.Hex()) > 0 {
				stmt.Exec(scans...)
			}
		}

		for i := range alarmDatas {
			alarm := alarmDatas[i]
			scans := make([]interface{}, 15)
			dateTime := TimeUtcToStr(alarm.Time)
			year := strconv.Itoa(alarm.Time.Year())
			month := Substr(dateTime, 5, 2)
			year_month_info := strings.Join([]string{year, month}, "-")
			siteInfo, ok := siteMap[alarm.Siteurlhash]
			var siteName, siteUrl string
			if ok {
				siteName = siteInfo.Sitename
				siteUrl = siteInfo.Siteurl
			} else {
				siteName = "已删除站点"
			}

			scans[0] = alarm.Id.Hex()
			scans[1] = siteName
			scans[2] = siteUrl
			scans[3] = year
			scans[4] = month

			scans[5] = year_month_info
			scans[6] = 0
			scans[7] = 0
			scans[8] = 0
			scans[9] = 1
			scans[10] = Substr(dateTime, 0, 10)
			scans[11] = impDate
			scans[12] = dbIni.SysType
			scans[13] = dbIni.SysId
			scans[14] = dbIni.SysName
			if len(alarm.Id.Hex()) > 0 {
				stmt.Exec(scans...)
			}
		}
		logger.Info("exec sysnc yearMonth end ......................", yearMonth, firstDay)
	}
}

/*执行数据同步*/
func (xmlInfo *XmlInfo) Run(dbIni *DBini) {
	logger.Info("All run begin >>>>>>>>>>>>>>>>")
	f_pwd, _ := Base64Dec(dbIni.F_Password)
	t_pwd, _ := Base64Dec(dbIni.T_Password)
	dbIni.F_Db.Db_open(dbIni.F_DbType, dbIni.F_User, f_pwd, dbIni.F_Ip, dbIni.F_Port, dbIni.F_Dbname)
	dbIni.T_Db.Db_open(dbIni.T_DbType, dbIni.T_User, t_pwd, dbIni.T_Ip, dbIni.T_Port, dbIni.T_Dbname)
	//关闭数据库
	defer dbIni.F_Db.db.Close()
	defer dbIni.T_Db.db.Close()

	if dbIni.F_Db.db == nil || dbIni.T_Db.db == nil {
		logger.Error("无法链接两方数据库")
		return
	}
	Reader(dbIni, xmlInfo)
	Writer(dbIni, xmlInfo)
	Updater(dbIni, xmlInfo)
	logger.Info("All run end >>>>>>>>>>>>>>>>")
	time.Sleep(5 * time.Second)
}

/*执行数据同步读取直接写入*/
func (xmlInfo *XmlInfo) RunDataPipe(dbIni *DBini) {
	logger.Info("All run begin >>>>>>>>>>>>>>>>")
	logger.Info("dbIni.F_DbType:", dbIni.F_DbType, "dbIni.T_DbType:", dbIni.T_DbType)
	if !StartFlag {
		return
	}
	f_pwd, _ := Base64Dec(dbIni.F_Password)
	t_pwd, _ := Base64Dec(dbIni.T_Password)
	dbIni.F_Db.Db_open(dbIni.F_DbType, dbIni.F_User, f_pwd, dbIni.F_Ip, dbIni.F_Port, dbIni.F_Dbname)
	dbIni.T_Db.Db_open(dbIni.T_DbType, dbIni.T_User, t_pwd, dbIni.T_Ip, dbIni.T_Port, dbIni.T_Dbname)
	//关闭数据库
	defer dbIni.F_Db.db.Close()
	defer dbIni.T_Db.db.Close()

	if dbIni.F_Db.db == nil || dbIni.T_Db.db == nil {
		logger.Error("无法链接两方数据库")
		return
	}
	DataPipe(dbIni, xmlInfo)
	Updater(dbIni, xmlInfo)
	logger.Info("All run end >>>>>>>>>>>>>>>>")
	time.Sleep(5 * time.Second)
}
