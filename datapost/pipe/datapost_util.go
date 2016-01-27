/*
* 工具函数
 */
package pipe

import (
	"bitbucket.org/kardianos/osext"
	"bitbucket.org/kardianos/service"
	"database/sql"
	b64 "encoding/base64"
	"encoding/json"
	"encoding/xml"
	"flag"
	"fmt"
	goconfig "github.com/dcmsy/datapost/goconfig"
	_ "github.com/denisenkom/go-mssqldb"
	"github.com/donnie4w/go-logger/logger"
	_ "github.com/go-sql-driver/mysql"
	"github.com/larspensjo/config"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"strings"
	"syscall"
	"time"
	"unsafe"
)

// base 64 加密
func Base64Enc(data string) string {
	var (
		enc string = ""
	)
	enc = b64.StdEncoding.EncodeToString([]byte(data))
	return enc
}

// base 64 解密
func Base64Dec(data string) (string, error) {
	var (
		dec string = ""
		err error
	)
	tmp, err := b64.StdEncoding.DecodeString(data)
	dec = string(tmp)
	return dec, err
}

/**获取目录下所有的xml文件名*/
func GetXmlFileNames(dirName string, filter string) map[string]string {
	var rootName string = "xml"
	s := []string{rootName, "/", dirName, "/"}
	var path = strings.Join(s, "")
	results := make(map[string]string)
	err := filepath.Walk(path, func(path string, f os.FileInfo, err error) error {
		if f == nil {
			return err
		}
		if f.IsDir() {
			return nil
		}
		if strings.LastIndex(path, "xml") > 3 && strings.Contains(path, filter) {
			results[path] = path
		}
		return nil
	})
	if err != nil {
		logger.Error("filepath.Walk() returned %v\n", err)
	}
	return results
}

/**获取目录下所有的xml文件名*/
func GetXmlIniNames() map[string]string {
	var rootName string = "xml"
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

/*测试获取xmlfilenames*/
func testGetXmlFileNames() {
	fileNames := GetXmlFileNames("HostAudit", "repeatetimer")
	for _, v := range fileNames {
		fmt.Println("fileNames:", v)
	}
}

/*获取数据库连接 支持mysql mssql mongodb*/
func (f *My_db) Db_open(dbtype string, dbusername string, dbpassowrd string, dbhostsip string, dbport string, dbname string) {
	var connString string
	if strings.EqualFold(dbtype, "mysql") { //root:@tcp(localhost:3306)/go?charset=utf8
		connString = fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8", dbusername, dbpassowrd, dbhostsip, dbport, dbname)
	} else if strings.EqualFold(dbtype, "mssql") {
		connString = fmt.Sprintf("server=%s;user id=%s;password=%s;port=%s;database=%s;encrypt=disable;", dbhostsip, dbusername, dbpassowrd, dbport, dbname)
	}
	Odb, err := sql.Open(dbtype, connString)
	if err != nil {
		logger.Error(err)
		logger.Error("链接失败 >dbusername:%s dbpassowrd:%s dbhostsip:%s dbname:%s", dbusername, dbpassowrd, dbhostsip, dbname)
		f.db = nil
	}
	f.db = Odb
}

/*测试读取xml*/
func TestReadXml() {
	content, err := ioutil.ReadFile("xml/HostAudit/repeatetimer_主机审计日志.xml")
	if err != nil {
		logger.Error(err)
	}
	var result XmlInfo
	err = xml.Unmarshal(content, &result)
	if err != nil {
		logger.Error(err)
	}
	logger.Debug(result.FileName)
}

/*读取ini配置文件*/
func GetConfig(configFile *string, sectionFlag string) map[string]string {
	var DIRS = make(map[string]string)
	//set config file std
	cfg, err := config.ReadDefault(*configFile)
	if err != nil {
		log.Fatalf("Fail to find", *configFile, err)
	}
	//Initialized from the configuration
	if cfg.HasSection(sectionFlag) {
		section, err := cfg.SectionOptions(sectionFlag)
		if err == nil {
			for _, v := range section {
				options, err := cfg.String(sectionFlag, v)
				if err == nil {
					DIRS[v] = options
				}
			}
		}
	}
	//Initialized dirs from the configuration END
	return DIRS
}

/*读取ini配置文件*/
func GetIni(rootPath string, filePath string, sectionFlag string) map[string]string {
	var configFile = flag.String(rootPath, filePath, "General configuration file")
	var DIRS = make(map[string]string)
	flag.Parse()
	//set config file std
	cfg, err := config.ReadDefault(*configFile)
	if err != nil {
		log.Fatalf("Fail to find", *configFile, err)
	}
	//Initialized from the configuration
	if cfg.HasSection(sectionFlag) {
		section, err := cfg.SectionOptions(sectionFlag)
		if err == nil {
			for _, v := range section {
				options, err := cfg.String(sectionFlag, v)
				if err == nil {
					DIRS[v] = options
				}
			}
		}
	}
	//Initialized dirs from the configuration END
	return DIRS
}

/*动态读取配置文件*/
func ReadIniFile(filePath string, section string) map[string]string {
	var DIRS = make(map[string]string)
	c, _ := goconfig.LoadConfigFile(filePath)
	DIRS, _ = c.GetGroup(section)
	return DIRS
}

const (
	f_datetime = "2006-01-02 15:04"
)

//将str转换为时间格式
func StrToTime(st string) time.Time {
	t, _ := time.ParseInLocation(f_datetime, st, time.Local)
	return t
}

//将UTC时间增加8小时为东部时间
func TimeUtcToCst(t time.Time) time.Time {
	return t.Add(time.Hour * time.Duration(8))
}

//将UTC时间增加8小时为东部时间 str
func TimeUtcToStr(t time.Time) string {
	t.Add(time.Hour * time.Duration(8))
	return Substr(t.String(), 0, 19)
}

//截取字符串
func Substr(str string, start, length int) string {
	rs := []rune(str)
	rl := len(rs)
	end := 0
	if start < 0 {
		start = rl - 1 + start
	}
	end = start + length

	if start > end {
		start, end = end, start
	}
	if start < 0 {
		start = 0
	}
	if start > rl {
		start = rl
	}
	if end < 0 {
		end = 0
	}
	if end > rl {
		end = rl
	}
	return string(rs[start:end])
}

//获取年月2014-06-30 11:13:57
func GetYearMonth(time string) string {
	var yearMonth string = ""
	ym := []string{"", ""}
	tmp := Substr(time, 0, 10)
	arr := strings.Split(tmp, "-")
	if len(arr) >= 2 {
		ym[0] = arr[0]
		ym[1] = arr[1]
	}
	yearMonth = strings.Join(ym, "")
	return yearMonth
}

//获取当前月的第一天2014-06-30 11:13:57
func GetMonthFirstDay(time string) string {
	var yearMonth string = ""
	ym := []string{"", "-01 00:00"}
	tmp := Substr(time, 0, 7)
	ym[0] = tmp
	yearMonth = strings.Join(ym, "")
	return yearMonth
}

//////////////////////////////////////////////

// ServiceHandle handle service events
func ServiceHandle(svcName, svcDisp, svcDesc string, work func(), stopWork func()) {
	if len(os.Args) > 1 {
		cmd := os.Args[1]
		var s, err = service.NewService(svcName, svcDisp, svcDesc)
		if err != nil {
			fmt.Printf("%s unable to start: %s", svcDisp, err)
			return
		}
		switch cmd {
		case "install":
			err = s.Install()
			if err != nil {
				fmt.Printf("Failed to install:%s\n", err)
				return
			}
			fmt.Printf("Service \"%s\" installed.\n", svcDisp)
		case "remove", "uninstall":
			err = s.Remove()
			if err != nil {
				fmt.Printf("Failed to remove: %s\n", err)
				return
			}
			fmt.Printf("Service \"%s\" removed.\n", svcDisp)
		case "start":
			err = s.Start()
			if err != nil {
				fmt.Printf("Failed to start: %s\n", err)
				return
			}
			fmt.Printf("Service \"%s\" started.\n", svcDisp)
		case "stop":
			err = s.Stop()
			if err != nil {
				fmt.Printf("Failed to stop: %s\n", err)
				return
			}
			fmt.Printf("Service \"%s\" stoped.\n", svcDisp)
		case "run":
			work()
		}
		return
	}
	var s, err = service.NewService(svcName, svcDisp, svcDesc)
	if err != nil {
		fmt.Printf("%s unable to start: %s", svcDisp, err)
		return
	}
	err = s.Run(func() error {
		go work()
		return nil
	}, func() error {
		stopWork()
		return nil
	})
	//	if err != nil {
	//		s.Error(err.Error())
	//	}
}

// OsRegGetValue read windows registry
func OsRegGetValue(path, key string) (v string) {
	var hKey syscall.Handle
	if err := syscall.RegOpenKeyEx(syscall.HKEY_LOCAL_MACHINE, syscall.StringToUTF16Ptr(path), 0, syscall.KEY_READ, &hKey); err != nil {
		return
	}
	defer syscall.RegCloseKey(hKey)
	var buf [1 << 10]uint16
	typ := uint32(0)
	n := uint32(len(buf) * 2)
	if err := syscall.RegQueryValueEx(hKey, syscall.StringToUTF16Ptr(key), nil, &typ, (*byte)(unsafe.Pointer(&buf[0])), &n); err != nil {
		return
	}
	if typ != syscall.REG_SZ {
		return
	}
	return syscall.UTF16ToString(buf[:])
}

// GetBinPath get current exe module dir
func GetBinPath() (path string) {
	path, _ = osext.ExecutableFolder()
	return
}

// Now return current date-time string
func Now() string {
	return time.Now().Format("2006-01-02 15:04:05")
}

// CfgMap parse config string to a map
func CfgMap(s string) (m map[string]string) {
	m = make(map[string]string)
	tmp := strings.Split(s, ",")
	if len(tmp) > 0 {
		for _, kv := range tmp {
			arr := strings.Split(kv, "=")
			if len(arr) == 2 {
				m[arr[0]] = arr[1]
			}
		}
	}
	return
}

// RPCGet do http json get
func RPCGet(apiURL string, req interface{}, resp interface{}) error {
	b, e := json.Marshal(req)
	if e != nil {
		return e
	}
	apiURL = apiURL + "?json=" + url.QueryEscape(string(b))
	res, err := http.Get(apiURL)
	if err != nil {
		return err
	}
	defer res.Body.Close()
	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		return err
	}
	err = json.Unmarshal(body, resp)
	if err != nil {
		return err
	}
	return nil
}

// RPCPost do http json post
func RPCPost(apiURL string, req interface{}, resp interface{}) error {
	b, e := json.Marshal(req)
	if e != nil {
		return e
	}
	v := url.Values{}
	v.Set("json", string(b))
	res, err := http.PostForm(apiURL, v)
	if err != nil {
		return err
	}
	defer res.Body.Close()
	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		return err
	}
	err = json.Unmarshal(body, resp)
	if err != nil {
		return err
	}
	return nil
}

// JSONLog log using json format
func JSONLog(pre string, v interface{}) {
	b, _ := json.Marshal(v)
	log.Println(pre, string(b))
}

/*执行exe*/
func callEXE(path string) {
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
