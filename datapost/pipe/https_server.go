/*
* 支持https数据传输
 */
package pipe

import (
	"encoding/json"
	"fmt"
	"github.com/donnie4w/go-logger/logger"
	"io/ioutil"
	"net/http"
	"net/url"
	"reflect"
	"strings"
	"unsafe"
)

type NetTransInfo struct {
	Id       string `json:"id"`
	Filename string `json:"filename"`
	Username string `json:"username"`
	Acttime  string `json:"acttime"`
	Result   string `json:"result"`
	Devid    string `json:"devid"`
	Devname  string `json:"devname"`
}

var InsertSQL string = "replace into tb_onewayinput_log(id,filename,username,acttime,result,sub_sysid,sub_sysname,stdorgid,stdorgname,impdate,dealflag,isreported,devid,devname)values(?,?,?,?,?,?,?,'','',now(),'0','0',?,?)"
var TimeDefaultValue string = "0000-00-00 00-00-00"

/**
* 处理单导传输数据
 */
func handler(w http.ResponseWriter, r *http.Request) {
	ret := true
	fmt.Println("接收到来自单导的数据提交请求...")

	defer func() {
		if err := recover(); err != nil {
			ret = false
			fmt.Fprintf(w, "fail")
			logger.Error("查询数据库失败", err)
		}
	}()
	defer r.Body.Close()
	ret_str, err := ioutil.ReadAll(r.Body)
	l3, _ := url.Parse(B2S(ret_str))
	fmtStr := l3.Path
	replace_fmtStr := strings.Replace(fmtStr, "dandaokey=", "", 1)
	fmt_ret_str := S2B(&replace_fmtStr)
	if err != nil {
		ret = false
		logger.Error(" err = ", err)
	}
	var infos []NetTransInfo
	err = json.Unmarshal(fmt_ret_str, &infos)
	if err != nil {
		ret = false
		logger.Error(" err = ", err)
	}
	//获取数据库配置信息
	config := new(IndexInfo)
	GetConfigFromIniFile(config, "Dd")
	dbIni := new(DBini)
	dbIni.T_Db.Db_open(config.T_dbtype, config.T_username, config.T_password, config.T_ip, config.T_port, config.T_dbname)
	defer dbIni.T_Db.db.Close()

	//查询数据库
	query, err := dbIni.T_Db.db.Query("SELECT 1")
	defer query.Close()
	if err != nil {
		ret = false
		logger.Error("查询数据库失败", err.Error())
		panic(err)
		return
	}
	//保存数据
	insertStmt, err := dbIni.T_Db.db.Prepare(InsertSQL)
	defer insertStmt.Close()
	if err != nil {
		ret = false
		logger.Error(err)
		panic(err)
		return
	}
	for i := range infos {
		info := &infos[i]
		insertScans := make([]interface{}, 9)
		insertScans[0] = info.Id
		insertScans[1] = info.Filename
		insertScans[2] = info.Username
		if len(info.Acttime) == 0 || strings.EqualFold(info.Acttime, "null") {
			insertScans[3] = TimeDefaultValue
		} else {
			insertScans[3] = info.Acttime
		}
		insertScans[4] = info.Result
		insertScans[5] = config.Sysid
		insertScans[6] = config.Sysname
		insertScans[7] = info.Devid
		insertScans[8] = info.Devname
		_, err := insertStmt.Exec(insertScans...)
		if err != nil {
			fmt.Fprintf(w, "fail")
			return
		}
	}
	//保存成功回复ok 否则 回复fail
	if ret {
		logger.Info("单导的数据接收ok....")
		fmt.Fprintf(w, "ok")
	} else {
		logger.Info("单导的数据接收fail....")
		fmt.Fprintf(w, "fail")
	}
}

/**
* byte 转换为 string
 */
func B2S(buf []byte) string {
	return *(*string)(unsafe.Pointer(&buf))
}

/**
* string转换为 byte
 */
func S2B(s *string) []byte {
	return *(*[]byte)(unsafe.Pointer((*reflect.SliceHeader)(unsafe.Pointer(s))))
}

/**
* 接入系统handler
 */
func nacHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "有待完善...")
}

/**
*启动https服务
 */
func Https_start() {
	//单导接口
	http.HandleFunc("/api/nettrans/put", handler)

	//接入接口
	http.HandleFunc("/api/nac/put", nacHandler)
	http.ListenAndServeTLS(":8881", "./keyfiles/server.crt", "./keyfiles/server.key", nil)
}
