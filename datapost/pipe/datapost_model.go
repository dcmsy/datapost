/**
 * model
 */
package pipe

import (
	"database/sql"
	"gopkg.in/mgo.v2/bson"
	"time"
)

/*db 句柄*/
type My_db struct {
	db *sql.DB
}

/*Node信息 Chk|网检系统|mssql|chkproof */
type Node struct {
	Id    string `json:"id"`
	Text  string `json:"text"`
	State string `json:"state"`
}

/*系统配置信息*/
type SysIni struct {
	//db配置信息
	dbini      DBini
	configInfo ConfigInfo
	//上报xml列表
	xmlInfoes       []XmlInfo
	singleXmlInfoes []XmlInfo
	xmlInfo         XmlInfo
}

/*配置界面*/
type ConfigInfo struct {
	singletimer  string
	repeatetimer string
	transferes   string
	nosql        string
	sites        string
}

/*数据库配置信息*/
type DBini struct {
	F_Db     My_db
	T_Db     My_db
	F_DbType string
	T_DbType string

	F_Driver   string
	F_Dburl    string
	F_Ip       string
	F_Port     string
	F_Dbname   string
	F_User     string
	F_Password string

	T_Driver   string
	T_Dburl    string
	T_Ip       string
	T_Port     string
	T_Dbname   string
	T_User     string
	T_Password string

	SysId    string
	SysType  string
	SysName  string
	Company  string
	Platform string
}

/*xml配置信息*/
type XmlInfo struct {
	FileName       string `xml:"filename,attr"`
	Remark         string `xml:"remark,attr"`
	RunModel       string `xml:"runmodel,attr"`
	IsValData      string `xml:"isvaldata,attr"`
	CheckRowSQL    string `xml:"CheckRowSQL"`
	UpdateOperSQL  string `xml:"UpdateOperSQL"`
	DeleteByIDSQL  string `xml:"DeleteByIDSQL"`
	CheckColumnSQL string `xml:"CheckColumnSQL"`
	AlterSQL       string `xml:"AlterSQL"`
	UpdateFlagSQL  string `xml:"UpdateFlagSQL"`
	DataSQL        string `xml:"DataSQL"`
	InsertSQL      string `xml:"InsertSQL"`
	SuccessSQL     string `xml:"SuccessSQL"`
	Ids            []string
	Datas          map[int]map[string]string
	Columns        []string
	GobalNum       int
	RowNum         int
	AlterFlag      bool
	CheckFlag      bool
	NotExistData   bool
}

/*站点*/
type Site struct {
	Id           bson.ObjectId `bson:"_id"`
	Numattention int32         `bson:"numattention"`
	Numnormal    int32         `bson:"numnormal"`
	Numsuspicion int32         `bson:"numsuspicion"`
	Numwarning   int32         `bson:"numwarning"`
	Organization string        `bson:"organization"`
	Remark       string        `bson:"remark"`
	Sitekind     string        `bson:"sitekind"`
	Sitename     string        `bson:"sitename"`
	Siteowner    string        `bson:"siteowner"`
	Siteruleid   string        `bson:"siteruleid"`
	Siteurl      string        `bson:"siteurl"`
	Siteurlhash  int32         `bson:"siteurlhash"`
	State        int32         `bson:"state"`
	Telphone     string        `bson:"telphone"`
}

/*alarmprint*/
type Alarmprint struct {
	Id          bson.ObjectId `bson:"_id"`
	Title       string        `bson:"title"`
	Url         string        `bson:"url"`
	Urlhash     int32         `bson:"urlhash"`
	Keywords    []string      `bson:"keywords"`
	Siteurlhash int32         `bson:"siteurlhash"`
	Time        time.Time     `bson:"time"`
	State       int32         `bson:"state"`
}

/*siteChartTable*/
type SiteChartTable struct {
	Id           bson.ObjectId `bson:"_id"`
	Siteurlhash  int32         `bson:"siteurlhash"`
	Year         string        `bson:"year"`
	Month        string        `bson:"month"`
	Numwarning   int32         `bson:"numwarning"`
	Numsuspicion int32         `bson:"numsuspicion"`
	Numattention int32         `bson:"numattention"`
}
