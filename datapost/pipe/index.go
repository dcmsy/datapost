package pipe

import (
	"encoding/json"
	"fmt"
	"github.com/astaxie/beego"
	goconfig "github.com/dcmsy/datapost/goconfig"
	"github.com/donnie4w/go-logger/logger"
	"gopkg.in/mgo.v2"
	"strings"
)

//配置信息
type IndexInfo struct {
	beego.Controller
	Singletimer  string
	Repeatetimer string
	Transferes   string
	Nosql        string

	F_ip       string
	F_port     string
	F_username string
	F_password string
	F_dbtype   string
	F_driver   string
	F_dbname   string

	T_ip       string
	T_port     string
	T_username string
	T_password string
	T_dbtype   string
	T_driver   string
	T_dbname   string

	Systype  string
	Dbtype   string
	Sysid    string
	Sysname  string
	Company  string
	Platform string
	Dirname  string
}

// Ret entity
type Ret struct {
	Code int    `json:"code"`
	Msg  string `json:"msg"`
}

const (
	HostAll string = "hostall"
)

//index
func (this *IndexInfo) Index() {
	l := len(SysMap)
	list := make([]*IndexInfo, l, l)
	for i := range SysArr {
		itemes := strings.Split(SysArr[i], "|")
		if len(itemes) == 4 {
			info := new(IndexInfo)
			info.Systype = itemes[0]
			info.Sysname = itemes[1]
			list[i] = info
		}
	}
	this.Data["list"] = list
	this.TplNames = "conf/index.html"
}

//帮助
func (this *IndexInfo) Help() {
	this.TplNames = "conf/help.html"
}

//列表
func (this *IndexInfo) List() {
	sys := this.GetString("sys")
	sysname := this.GetString("sysname")
	config := new(IndexInfo)
	configMap := ReadIniFile("config/config.ini", "config")
	config.Transferes = configMap["transferes"]
	config.Nosql = configMap["nosql"]
	GetConfigFromIniFile(config, sys)

	l := len(SysMap)
	list := make([]*IndexInfo, l, l)
	list2 := make([]*IndexInfo, l, l)
	for i := range SysArr {
		itemes := strings.Split(SysArr[i], "|")
		info := new(IndexInfo)
		if len(itemes) == 4 {
			info.Systype = itemes[0]
			info.Sysname = itemes[1]
		}
		if i < 7 {
			list[i] = info
		} else {
			list2[i] = info
		}
	}

	this.Data["list"] = list
	this.Data["list2"] = list2
	this.Data["config"] = config
	this.Data["sys"] = sys
	this.Data["sysname"] = sysname
	this.TplNames = "conf/conf.html"
}

//获取当前treedata
func (this *IndexInfo) TreeData() {
	size := len(SysMap)
	var (
		nodes     = make([]Node, size)
		i     int = 0
	)
	for k, v := range SysMap {
		itemes := strings.Split(v, "|")
		if len(itemes) == 4 {
			nodes[i].Id = k
			nodes[i].Text = itemes[1]
			nodes[i].State = "open"
		}
		i++
	}
	this.Data["json"] = &nodes
	this.ServeJson()
}

//编辑
func (this *IndexInfo) Edit() {
	var (
		config = new(IndexInfo)
		err    error
		ret    Ret
		flag   bool
	)
	if err = json.Unmarshal([]byte(this.GetString("json")), &config); err == nil {
		err = config.SaveSingleConf()
	}
	if err != nil {
		logger.Error(err)
		ret.Code, ret.Msg = 1, err.Error()
		flag = false
		logger.Info("Edit", err.Error())
	} else {
		ret.Code = 0
		flag = true
	}
	this.Data["json"] = &ret
	this.ServeJson(flag)
}

//测试连接
func (this *IndexInfo) Test() {
	var (
		config     = new(IndexInfo)
		err        error
		ret        Ret
		db                = new(My_db)
		dbtype     string = "mysql"
		dbusername string
		dbpassowrd string
		dbhostsip  string
		dbport     string
		dbname     string
	)
	logger.Info("dbtype=", dbtype)
	if err = json.Unmarshal([]byte(this.GetString("json")), &config); err == nil {
		dbusername = config.F_username
		dbpassowrd, _ = Base64Dec(config.F_password)
		dbhostsip = config.F_ip
		dbport = config.F_port
		dbname = config.F_dbname
		dbtype = config.F_dbtype
		if !strings.EqualFold(dbtype, "mgo") {
			db.Db_open(dbtype, dbusername, dbpassowrd, dbhostsip, dbport, dbname)
			logger.Info("dbtype=", dbtype)
		}
	}
	logger.Info("dbtype, dbusername, dbpassowrd, dbhostsip, dbport, dbname", dbtype, dbusername, dbpassowrd, dbhostsip, dbport, dbname)
	if strings.EqualFold(dbtype, "mgo") {
		connString := fmt.Sprintf("%s:%s", dbhostsip, dbport)
		session, er := mgo.Dial(connString)
		defer session.Close()
		if er != nil {
			ret.Code = 0
			this.Data["json"] = &ret
			err = er
			panic(er)
		} else {
			ret.Code = 0
		}
	} else {
		if err != nil {
			logger.Error(err)
			ret.Code, ret.Msg = 1, err.Error()
		} else {

			if db.db != nil {
				defer db.db.Close()
				query, err := db.db.Query("select 1")
				if err != nil {
					logger.Info("err====", err)
					ret.Code = 1
				} else {
					if query.Next() {
						ret.Code = 0
					} else {
						ret.Code = 1
					}
					defer query.Close()
				}
			} else {
				ret.Code = 1
			}
		}
	}
	this.Data["json"] = &ret
	this.ServeJson()
}

//保存单个系统配置文件
func (this *IndexInfo) SaveSingleConf() (err error) {
	var (
		cfgPath string = "config/config.ini"
		retErr  error
	)
	cfg, _ := goconfig.LoadConfigFile(cfgPath)
	IndexInfoToCfg(this, cfg)
	retErr = goconfig.SaveConfig(cfg, cfgPath)
	iniPath := "xml/" + this.Dirname + "/" + this.Dirname + ".ini"
	xmlIniCfg, _ := goconfig.LoadConfigFile(iniPath)
	IndexInfoToIni(this, xmlIniCfg)
	retErr = goconfig.SaveConfig(xmlIniCfg, iniPath)
	return retErr
}

//保存所有配置文件
func (this *IndexInfo) SaveAllConf() (err error) {
	var (
		cfgPath string = "config/config.ini"
		retErr  error
	)
	xmlInies := GetXmlIniNames()
	cfg, _ := goconfig.LoadConfigFile(cfgPath)
	IndexInfoToCfg(this, cfg)
	retErr = goconfig.SaveConfig(cfg, cfgPath)
	for _, v := range xmlInies {
		xmlIniCfg, _ := goconfig.LoadConfigFile(v)
		IndexInfoToIni(this, xmlIniCfg)
		retErr = goconfig.SaveConfig(xmlIniCfg, v)
	}
	return retErr
}

//indexinfo to cfg
func IndexInfoToCfg(this *IndexInfo, cfg *goconfig.Config) {

	repeatetimer, _ := cfg.Get("config::repeatetimer")
	singletimer, _ := cfg.Get("config::singletimer")

	configpage, _ := cfg.Get("config::configpage")
	sites, _ := cfg.Get("config::sites")

	cfg.Set("config", "repeatetimer", repeatetimer)
	cfg.Set("config", "singletimer", singletimer)
	cfg.Set("config", "configpage", configpage)
	cfg.Set("config", "sites", sites)
	cfg.Set("config", "transferes", this.Transferes)
	cfg.Set("config", "nosql", this.Nosql)
}

//indexinfo to ini
func IndexInfoToIni(this *IndexInfo, cfg *goconfig.Config) {
	f_dbname, _ := cfg.Get("dbconfig::f_dbname")
	t_dbname, _ := cfg.Get("dbconfig::t_dbname")

	f_dbtype, _ := cfg.Get("dbconfig::f_dbtype")
	f_driver, _ := cfg.Get("dbconfig::f_driver")
	t_dbtype, _ := cfg.Get("dbconfig::t_dbtype")
	t_driver, _ := cfg.Get("dbconfig::t_driver")

	var f_dburl string = ""
	if strings.EqualFold(f_dbtype, "mysql") {
		f_dburl_arr := []string{"jdbc:mysql://", this.F_ip, ":", this.F_port, "/", f_dbname, "?useUnicode=true&characterEncoding=utf-8&useOldAliasMetadataBehavior=true"}
		f_dburl = strings.Join(f_dburl_arr, "")
	} else if strings.EqualFold(f_dbtype, "mssql") {
		f_dburl_arr := []string{"jdbc:microsoft:sqlserver://", this.F_ip, ":", this.F_port, ";", "DatabaseName=", f_dbname}
		f_dburl = strings.Join(f_dburl_arr, "")
	}
	t_dburl_arr := []string{"jdbc:mysql://", this.T_ip, ":", this.T_port, "/", t_dbname, "?useUnicode=true&characterEncoding=utf-8&useOldAliasMetadataBehavior=true"}
	var t_dburl = strings.Join(t_dburl_arr, "")

	cfg.Set("dbconfig", "f_dbtype", f_dbtype)
	cfg.Set("dbconfig", "f_driver", f_driver)
	cfg.Set("dbconfig", "f_dburl", f_dburl)
	cfg.Set("dbconfig", "f_ip", this.F_ip)
	cfg.Set("dbconfig", "f_port", this.F_port)
	cfg.Set("dbconfig", "f_dbname", f_dbname)
	cfg.Set("dbconfig", "f_user", this.F_username)
	cfg.Set("dbconfig", "f_password", this.F_password)

	cfg.Set("dbconfig", "t_dbtype", t_dbtype)
	cfg.Set("dbconfig", "t_driver", t_driver)
	cfg.Set("dbconfig", "t_dburl", t_dburl)
	cfg.Set("dbconfig", "t_ip", this.T_ip)
	cfg.Set("dbconfig", "t_port", this.T_port)
	cfg.Set("dbconfig", "t_dbname", t_dbname)
	cfg.Set("dbconfig", "t_user", this.T_username)
	cfg.Set("dbconfig", "t_password", this.T_password)

	sysid, _ := cfg.Get("dbconfig::sysid")
	systype, _ := cfg.Get("dbconfig::systype")
	sysname, _ := cfg.Get("dbconfig::sysname")
	company, _ := cfg.Get("dbconfig::company")
	platform, err := cfg.Get("dbconfig::platform")
	logger.Info("platform===========================", platform, sysname, err)
	cfg.Set("dbconfig", "sysid", sysid)
	cfg.Set("dbconfig", "systype", systype)
	cfg.Set("dbconfig", "sysname", sysname)
	cfg.Set("dbconfig", "company", company)
	cfg.Set("dbconfig", "platform", platform)

}

//map to struct
func GetConfigFromMap(config *IndexInfo, cfgMap map[string]string) {
	config.Singletimer = cfgMap["singletimer"]
	config.Repeatetimer = cfgMap["repeatetimer"]
	config.Transferes = cfgMap["transferes"]
	config.Nosql = cfgMap["nosql"]

	if len(config.Transferes) > 0 && len(config.Nosql) > 0 {
		config.Systype = config.Transferes + "," + config.Nosql
	} else if len(config.Transferes) > 0 {
		config.Systype = config.Transferes
	} else if len(config.Nosql) > 0 {
		config.Systype = config.Nosql
	} else {
		config.Systype = ""
	}
}

//ini to config
func GetConfigFromIniFile(config *IndexInfo, dirName string) {
	iniMap := ReadIniFile("xml/"+dirName+"/"+dirName+".ini", "dbconfig")
	config.F_ip = iniMap["f_ip"]
	config.F_port = iniMap["f_port"]
	config.F_username = iniMap["f_user"]
	config.F_password, _ = Base64Dec(iniMap["f_password"])
	config.F_dbtype = iniMap["f_dbtype"]
	config.F_driver = iniMap["f_driver"]
	config.F_dbname = iniMap["f_dbname"]

	config.T_ip = iniMap["t_ip"]
	config.T_port = iniMap["t_port"]
	config.T_username = iniMap["t_user"]
	config.T_password, _ = Base64Dec(iniMap["t_password"])
	config.T_dbtype = iniMap["t_dbtype"]
	config.T_driver = iniMap["t_driver"]
	config.T_dbname = iniMap["t_dbname"]
	config.Systype = dirName
	config.Sysid = iniMap["sysid"]
	config.Sysname = iniMap["sysname"]
}
