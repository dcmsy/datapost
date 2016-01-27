/**
 * 文件操作
 */
package pipe

import (
	"github.com/donnie4w/go-logger/logger"
	"io"
	"os"
	"path/filepath"
	"strings"
)

/*文件操作*/
func InitFile() error {
	var src string = "conf/config.ini"
	var dest string = "config/config.ini"
	copyFile(src, dest)
	err := copyIniFiles()
	return err
}

/*复制所有ini文件*/
func copyIniFiles() error {
	var rootName string = "xml_ini"
	var desRootName string = "xml"
	var suffix string = ".ini"
	var rootPath string = "xml_ini//xml_ini.ini"
	var fileFilter string = "/"
	s := []string{rootName, fileFilter}
	var path = strings.Join(s, "")
	results := make(map[string]string)
	err := filepath.Walk(path, func(path string, f os.FileInfo, err error) error {
		if f == nil {
			return err
		}
		if f.IsDir() {
			iniFile := path + fileFilter + f.Name() + suffix
			desIniFile := strings.Replace(path, rootName, desRootName, -1) + fileFilter + f.Name() + suffix
			if !strings.EqualFold(iniFile, rootPath) && strings.HasSuffix(iniFile, suffix) {
				results[desIniFile] = iniFile
				copyFile(iniFile, desIniFile)
			}
		}
		return nil
	})
	if err != nil {
		logger.Error("filepath.Walk() returned %v\n", err)
	}
	return err
}

/*复制文件 如果存在则不再复制*/
func copyFile(src, dest string) error {
	srcFile, e := os.Open(src)
	if e != nil {
		logger.Error("copyFile:", e.Error())
		return e
	}
	defer srcFile.Close()

	df, e := os.Open(dest)
	defer df.Close()
	if e != nil && os.IsNotExist(e) {
		logger.Info("desIniFile:", dest, "file not exist!")
		destFile, e := os.Create(dest)
		if e != nil {
			logger.Error("copyFile destFile:", e.Error())
			return e
		}
		defer destFile.Close()
		io.Copy(destFile, srcFile)
		logger.Info("copy file from :", src, " to ", dest)
	} else {
		logger.Info("desIniFile:", dest, "已存在")
	}
	return nil
}
