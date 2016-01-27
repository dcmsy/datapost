/*
* 支持异构版本升级
 */
package pipe

import (
	"encoding/xml"
	"fmt"
	goconfig "github.com/dcmsy/datapost/goconfig"
	"github.com/donnie4w/go-logger/logger"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
	"syscall"
	"unsafe"
)

var (
	goldCfg = OsRegGetValue(`SOFTWARE\IntaxRegistry\rptpost`, "path")
	gnewCfg = OsRegGetValue(`SOFTWARE\IntaxRegistry\rptdata.post`, "path")
)

/*xml配置信息*/
type XmlInfo_upgrade struct {
	Classname   string `xml:"classname,attr"`
	Dictoryname string `xml:"dictoryname,attr"`
	Remark      string `xml:"remark,attr"`
	State       string `xml:"state,attr"`
}

/*xml配置信息*/
type Provider_upgrade struct {
	Sys Syses_upgrade `xml:"providerconfig"`
}
type Syses_upgrade struct {
	Provider []XmlInfo_upgrade `xml:"provider"`
}

/**设置xml*/
func joinXml() {
	defer func() {
		if err := recover(); err != nil {
			logger.Error("joinXml捕获到异常：", err)
		}
	}()
	content, err := ioutil.ReadFile("DataProvider.xml")
	if err != nil {
		panic(err)
		logger.Error(err)
	}
	var result Provider_upgrade
	err = xml.Unmarshal(content, &result)
	if err != nil {
		panic(err)
		logger.Error(err)
	}
	trans := ""
	notrans := ""
	j := 0
	for i := range result.Sys.Provider {
		logger.Info(result.Sys.Provider[i].Dictoryname)
		state := result.Sys.Provider[i].State
		if strings.EqualFold(state, "start") {
			logger.Info("state================", state)
			dirName := result.Sys.Provider[i].Dictoryname
			if strings.Contains(dirName, "Network") {
				notrans = "Network"
			} else {
				if j == 0 {
					trans = dirName
				} else {
					s := []string{trans, dirName}
					trans = strings.Join(s, ",")
				}
				j++
			}
		}
	}
	logger.Info("trans================", trans)
	logger.Info("notrans================", notrans)
	cfg, bakErr := goconfig.LoadConfigFile("conf/config.ini")
	if bakErr == nil {
		sites, _ := cfg.Get("config::sites")
		transferes, _ := cfg.Get("config::transferes")
		nosql, _ := cfg.Get("config::nosql")
		singletimer, _ := cfg.Get("config::singletimer")
		repeatetimer, _ := cfg.Get("config::repeatetimer")
		configpage, _ := cfg.Get("config::configpage")

		if len(trans) > 0 {
			transferes = trans
		}
		if len(notrans) > 0 {
			nosql = notrans
		}

		cfg.Set("config", "sites", sites)
		cfg.Set("config", "transferes", transferes)
		cfg.Set("config", "nosql", nosql)
		cfg.Set("config", "singletimer", singletimer)
		cfg.Set("config", "repeatetimer", repeatetimer)
		cfg.Set("config", "configpage", configpage)
		retErr := goconfig.SaveConfig(cfg, "conf/config.ini")
		if retErr != nil {
			logger.Error("retErr=", retErr)
		}
	}
}

/*执行异构版本升级*/
func Upgrade() {

	//执行文件备份
	copyIniFiles_local()

	//copyfiles
	if len(goldCfg) > 0 {
		xmlFilePath := goldCfg + "/plugins/java.rpt.datapost/WebRoot/xmlConf/DataProvider.xml"
		copyFile(xmlFilePath, "DataProvider.xml")
		//执行xml文件合并
		joinXml()

		//执行ini文件合并
		joinFiles()

		//执行卸载
		path := goldCfg + "/uninst.exe"
		callEXEByShell(path)
	}

	fmt.Println("goldCfg=", goldCfg)
	fmt.Println("gnewCfg=", gnewCfg)
}

/**call exe*/
func callEXEByShell(path string) {
	var hand uintptr = uintptr(0)
	var operator uintptr = uintptr(unsafe.Pointer(syscall.StringToUTF16Ptr("open")))
	var fpath uintptr = uintptr(unsafe.Pointer(syscall.StringToUTF16Ptr(path)))
	var param uintptr = uintptr(unsafe.Pointer(syscall.StringToUTF16Ptr("/S")))
	var dirpath uintptr = uintptr(0)
	var ncmd uintptr = uintptr(1)
	shell32 := syscall.NewLazyDLL("shell32.dll")
	ShellExecuteW := shell32.NewProc("ShellExecuteW")
	_, _, _ = ShellExecuteW.Call(hand, operator, fpath, param, dirpath, ncmd)
}

/**合并文件*/
func joinFiles() {
	//判断密码是否以enc`开头，去掉enc`
	bakXmlInies := getXmlNames("xml_bak")
	for _, bakPath := range bakXmlInies {
		newIniPath := strings.Replace(bakPath, "xml_bak", "xml_ini", 1)
		bakXmlIniCfg, bakErr := goconfig.LoadConfigFile(bakPath)
		newXmlIniCfg, newErr := goconfig.LoadConfigFile(newIniPath)
		if bakXmlIniCfg != nil && newXmlIniCfg != nil && bakErr == nil && newErr == nil { //替换文件
			joinToIni(bakXmlIniCfg, newXmlIniCfg)
			retErr := goconfig.SaveConfig(newXmlIniCfg, newIniPath)
			if retErr != nil {
				logger.Error("retErr=", retErr)
			}
		}
	}
}

/**获取目录下所有的xml文件名*/
func getXmlNames(rootName string) map[string]string {
	s := []string{rootName, "/"}
	var path = strings.Join(s, "")
	results := make(map[string]string)
	err := filepath.Walk(path, func(path string, f os.FileInfo, err error) error {
		if f == nil {
			return err
		}
		if f.IsDir() {
			iniFile := path + "/" + f.Name() + ".ini"
			if !strings.EqualFold(iniFile, "xml//xml.ini") {
				results[iniFile] = iniFile
			}
		}
		return nil
	})
	if err != nil {
		logger.Error("filepath.Walk() returned %v\n", err)
	}
	return results
}

//indexinfo to ini
func joinToIni(bakCfg *goconfig.Config, cfg *goconfig.Config) {
	f_dbname, _ := cfg.Get("dbconfig::f_dbname")
	t_dbname, _ := cfg.Get("dbconfig::t_dbname")

	f_dbtype, _ := cfg.Get("dbconfig::f_dbtype")
	f_driver, _ := cfg.Get("dbconfig::f_driver")

	f_dburl, _ := bakCfg.Get("dbconfig::dburl")
	f_ip, _ := bakCfg.Get("dbconfig::ip")
	f_port, _ := bakCfg.Get("dbconfig::port")
	f_user, _ := bakCfg.Get("dbconfig::user")
	f_password, _ := bakCfg.Get("dbconfig::password")

	f_dburl_cfg, _ := cfg.Get("dbconfig::dburl")
	f_ip_cfg, _ := cfg.Get("dbconfig::ip")
	f_port_cfg, _ := cfg.Get("dbconfig::port")
	f_user_cfg, _ := cfg.Get("dbconfig::user")
	f_password_cfg, _ := cfg.Get("dbconfig::password")

	if len(f_dburl) <= 0 {
		f_dburl = f_dburl_cfg
	}
	if len(f_ip) <= 0 {
		f_ip = f_ip_cfg
	}
	if len(f_port) <= 0 {
		f_port = f_port_cfg
	}
	if len(f_user) <= 0 {
		f_user = f_user_cfg
	}
	if len(f_password) <= 0 {
		f_password = f_password_cfg
	}

	f_password = strings.Replace(f_password, "enc`", "", 1)

	t_dbtype, _ := cfg.Get("dbconfig::t_dbtype")
	t_driver, _ := cfg.Get("dbconfig::t_driver")
	t_dburl, _ := cfg.Get("dbconfig::t_dburl")
	t_ip, _ := cfg.Get("dbconfig::t_ip")
	t_port, _ := cfg.Get("dbconfig::t_port")
	t_user, _ := cfg.Get("dbconfig::t_user")
	t_password, _ := cfg.Get("dbconfig::t_password")

	cfg.Set("dbconfig", "f_dbtype", f_dbtype)
	cfg.Set("dbconfig", "f_driver", f_driver)
	cfg.Set("dbconfig", "f_dburl", f_dburl)
	cfg.Set("dbconfig", "f_ip", f_ip)
	cfg.Set("dbconfig", "f_port", f_port)
	cfg.Set("dbconfig", "f_dbname", f_dbname)
	cfg.Set("dbconfig", "f_user", f_user)
	cfg.Set("dbconfig", "f_password", f_password)

	cfg.Set("dbconfig", "t_dbtype", t_dbtype)
	cfg.Set("dbconfig", "t_driver", t_driver)
	cfg.Set("dbconfig", "t_dburl", t_dburl)
	cfg.Set("dbconfig", "t_ip", t_ip)
	cfg.Set("dbconfig", "t_port", t_port)
	cfg.Set("dbconfig", "t_dbname", t_dbname)
	cfg.Set("dbconfig", "t_user", t_user)
	cfg.Set("dbconfig", "t_password", t_password)

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

/**复制所有ini文件*/
func copyIniFiles_local() error {
	if len(goldCfg) <= 0 {
		return nil
	}
	defer func() {
		if err := recover(); err != nil {
			logger.Fatal("捕获到异常：", err)
		}
	}()
	var rootName string = "plugins/java.rpt.datapost/WebRoot/xmlConf/"
	var desRootName string = "xml_bak"
	var suffix string = ".ini"
	var rootPath string = "xml_ini//xml_ini.ini"
	var fileFilter string = "/"
	s := []string{goldCfg, rootName}
	var path = strings.Join(s, "/")
	results := make(map[string]string)
	err := filepath.Walk(path, func(path string, f os.FileInfo, err error) error {
		if f == nil {
			return err
		}
		if f.IsDir() {
			iniFile := path + fileFilter + f.Name() + suffix
			desIniFile := strings.Replace("xml_bak/"+f.Name(), rootName, desRootName, -1) + fileFilter + f.Name() + suffix
			if !strings.EqualFold(iniFile, rootPath) && strings.HasSuffix(iniFile, suffix) {
				results[desIniFile] = iniFile
				copyFile(iniFile, desIniFile)
			}
		}
		return nil
	})
	if err != nil {
		panic(err)
		logger.Error("filepath.Walk() returned %v\n", err)
	}
	return err
}
