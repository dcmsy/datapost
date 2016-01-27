/*
SQLyog 企业版 - MySQL GUI v7.14 
MySQL - 5.5.15 : Database - mid
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE DATABASE /*!32312 IF NOT EXISTS*/`mid` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_bin */;

USE `mid`;

/*Table structure for table `t_deviceviolatelog` */

DROP TABLE IF EXISTS `t_deviceviolatelog`;

CREATE TABLE `t_deviceviolatelog` (
  `id` varchar(200) NOT NULL,
  `hostname` varchar(1024) DEFAULT '',
  `empname` varchar(512) DEFAULT '',
  `deptname` varchar(512) DEFAULT '',
  `equname` varchar(200) DEFAULT '',
  `exteninfo` varchar(512) DEFAULT '',
  `violatetime` varchar(200) DEFAULT '',
  `netip` varchar(200) DEFAULT '0',
  `sub_sysid` varchar(36) DEFAULT '',
  `sub_sysname` varchar(60) DEFAULT '',
  `impdate` datetime DEFAULT NULL,
  `isreported` varchar(2) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `t_internetviolatelog` */

DROP TABLE IF EXISTS `t_internetviolatelog`;

CREATE TABLE `t_internetviolatelog` (
  `id` varchar(200) NOT NULL,
  `hostname` varchar(1024) DEFAULT '',
  `empname` varchar(512) DEFAULT '',
  `deptname` varchar(512) DEFAULT '',
  `macaddress` varchar(200) DEFAULT '',
  `harddiskinfo` varchar(200) DEFAULT '',
  `violatetime` varchar(200) DEFAULT '',
  `netip` varchar(200) DEFAULT '',
  `description` text,
  `sub_sysid` varchar(36) DEFAULT '',
  `sub_sysname` varchar(60) DEFAULT '',
  `impdate` datetime DEFAULT NULL,
  `isreported` varchar(2) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `t_operationviolatelog` */

DROP TABLE IF EXISTS `t_operationviolatelog`;

CREATE TABLE `t_operationviolatelog` (
  `id` varchar(200) NOT NULL,
  `hostname` varchar(1024) DEFAULT '',
  `empname` varchar(512) DEFAULT '',
  `deptname` varchar(512) DEFAULT '',
  `hostip` varchar(200) DEFAULT '',
  `macaddress` varchar(200) DEFAULT '',
  `opertime` varchar(200) DEFAULT '',
  `description` text,
  `sub_sysid` varchar(36) DEFAULT '',
  `sub_sysname` varchar(60) DEFAULT '',
  `impdate` datetime DEFAULT NULL,
  `isreported` varchar(2) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tb_alarm_log` */

DROP TABLE IF EXISTS `tb_alarm_log`;

CREATE TABLE `tb_alarm_log` (
  `logid` varchar(100) NOT NULL,
  `hostname` varchar(200) DEFAULT NULL,
  `zone` varchar(20) DEFAULT NULL,
  `unitid` varchar(20) DEFAULT NULL,
  `unitname` varchar(60) DEFAULT NULL,
  `deptid` varchar(20) DEFAULT NULL,
  `deptname` varchar(60) DEFAULT NULL,
  `userid` varchar(20) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `ncard` varchar(60) DEFAULT NULL,
  `mac` text,
  `hostip` text,
  `os` varchar(60) DEFAULT NULL,
  `mboard` text,
  `hdid` text,
  `ver` varchar(20) DEFAULT NULL,
  `logdate` date DEFAULT NULL,
  `logdesc` varchar(255) DEFAULT NULL,
  `company` varchar(20) DEFAULT NULL,
  `reserve` varchar(60) DEFAULT NULL,
  `receiveDate` varchar(10) DEFAULT NULL,
  `processDate` varchar(20) DEFAULT NULL,
  `processFlag` varchar(2) DEFAULT NULL,
  `resultInfo` varchar(255) DEFAULT NULL,
  `program` varchar(255) DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `stddeptid` varchar(100) DEFAULT NULL,
  `impsyscode` varchar(36) DEFAULT NULL,
  `impsysname` varchar(60) DEFAULT NULL,
  `isreported` varchar(2) DEFAULT '0',
  `stdorgid` varchar(36) DEFAULT NULL,
  `stdorgname` varchar(255) DEFAULT NULL,
  `sub_sysid` varchar(36) DEFAULT NULL,
  `sub_sysname` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`logid`),
  KEY `logid` (`logid`),
  KEY `idx_logdate` (`logdate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_cdburn_action` */

DROP TABLE IF EXISTS `tb_cdburn_action`;

CREATE TABLE `tb_cdburn_action` (
  `actionid` varchar(100) NOT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) DEFAULT NULL,
  `createDate` datetime DEFAULT NULL,
  `discCode` varchar(40) DEFAULT NULL,
  `authmode` varchar(10) DEFAULT NULL,
  `discType` varchar(10) DEFAULT NULL COMMENT '光盘类型',
  `disctypename` varchar(40) DEFAULT NULL COMMENT '光盘类型名称',
  `discPhytype` varchar(10) DEFAULT NULL COMMENT '光盘物理类型',
  `discphytypename` varchar(40) DEFAULT NULL COMMENT '光盘物理类型名称',
  `discVolume` varchar(10) DEFAULT NULL,
  `hostid` varchar(40) DEFAULT NULL,
  `hostname` varchar(200) DEFAULT NULL,
  `auditor` varchar(20) DEFAULT NULL,
  `flowType` varchar(10) DEFAULT NULL,
  `optype` varchar(10) DEFAULT NULL COMMENT '光盘操作类型',
  `optypename` varchar(40) DEFAULT NULL COMMENT '光盘操作类型',
  `beginDate` varchar(20) DEFAULT NULL,
  `endDate` varchar(20) DEFAULT NULL,
  `burnIp` varchar(20) DEFAULT NULL,
  `burnMac` varchar(40) DEFAULT NULL,
  `errCode` varchar(10) DEFAULT NULL,
  `completeness` varchar(10) DEFAULT NULL,
  `burnCount` int(11) DEFAULT '0',
  `burnSize` decimal(10,2) DEFAULT '0.00',
  `deptname` varchar(1000) DEFAULT NULL,
  `nodeid` varchar(36) DEFAULT NULL,
  `compend` varchar(500) DEFAULT NULL,
  `detail` varchar(500) DEFAULT NULL,
  `seclevel` varchar(10) DEFAULT NULL,
  `seclevelname` varchar(40) DEFAULT NULL,
  `cdRecord` varchar(40) DEFAULT NULL,
  `accName` varchar(100) DEFAULT NULL,
  `discRange` varchar(500) DEFAULT NULL,
  `resname` varchar(20) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `auditCode` varchar(36) DEFAULT NULL,
  `auditName` varchar(100) DEFAULT NULL,
  `cdstate` varchar(20) DEFAULT NULL,
  `cdstatename` varchar(100) DEFAULT NULL,
  `program` varchar(40) DEFAULT NULL,
  `isviolation` varchar(40) DEFAULT NULL,
  `sub_sysid` varchar(36) DEFAULT NULL,
  `sub_sysname` varchar(60) DEFAULT NULL,
  `stdorgid` varchar(100) DEFAULT NULL,
  `stdorgname` varchar(255) DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  PRIMARY KEY (`actionid`),
  KEY `idx_createdate` (`createDate`),
  KEY `idx_dealflag` (`dealflag`),
  KEY `idx_disccode` (`discCode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_cdburn_disc` */

DROP TABLE IF EXISTS `tb_cdburn_disc`;

CREATE TABLE `tb_cdburn_disc` (
  `id` varchar(100) COLLATE utf8_bin NOT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `createDate` datetime DEFAULT NULL,
  `discCode` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `discType` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `discTypename` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `discPhytype` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `discphytypename` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `discVolume` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `cdstate` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `cdstatename` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `hostid` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `hostname` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `auditor` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `optype` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `optypename` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `errCode` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `completeness` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `nodeid` varchar(36) COLLATE utf8_bin DEFAULT NULL,
  `deptname` varchar(1000) COLLATE utf8_bin DEFAULT NULL,
  `compend` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `detail` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `seclevel` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `seclevelname` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `accname` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `resname` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `auditName` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `remark` varchar(500) COLLATE utf8_bin DEFAULT NULL,
  `sub_sysid` varchar(36) COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `isreported` varchar(2) COLLATE utf8_bin DEFAULT '0',
  `oper_flag` varchar(2) COLLATE utf8_bin DEFAULT 'i',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `idx_createDate` (`createDate`),
  KEY `idx_year` (`year_info`),
  KEY `idx_dealflag` (`dealflag`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `tb_cdburn_files` */

DROP TABLE IF EXISTS `tb_cdburn_files`;

CREATE TABLE `tb_cdburn_files` (
  `id` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '主键',
  `actionid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '动作主键',
  `createDate` datetime DEFAULT NULL COMMENT '发生日期',
  `year_info` int(11) DEFAULT '0' COMMENT '年份',
  `month_info` int(11) DEFAULT '0' COMMENT '月份',
  `year_month_info` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '年月',
  `deptname` varchar(1000) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '部门名称',
  `username` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `discid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `filename` varchar(400) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `filetype` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `filesize` decimal(10,2) DEFAULT NULL,
  `sourcePath` varchar(500) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `targetPath` varchar(500) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `fileid` varchar(36) DEFAULT '0',
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `sumflag` int(1) DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  `stdorgname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_createdate` (`createDate`),
  KEY `idx_dealflag` (`dealflag`),
  KEY `idx_filename` (`filename`(333)),
  KEY `idx_sumflag` (`sumflag`),
  KEY `idx_fileid` (`fileid`),
  KEY `idx_actionid` (`actionid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_fxpg_assessment_item_result` */

DROP TABLE IF EXISTS `tb_fxpg_assessment_item_result`;

CREATE TABLE `tb_fxpg_assessment_item_result` (
  `batchno` varchar(36) COLLATE utf8_bin NOT NULL DEFAULT '',
  `rootcode` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `rootcontent` varchar(30) COLLATE utf8_bin DEFAULT NULL,
  `rootfullgrade` float DEFAULT NULL,
  `rootgrade` float DEFAULT NULL,
  `parentcode` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `parentcontent` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `parentfullgrade` float DEFAULT NULL,
  `parentgrade` float DEFAULT NULL,
  `itemcode` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `itemcontent` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `itemfullgrade` float DEFAULT NULL,
  `itemgrade` float DEFAULT NULL,
  `subcode` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `subcontent` text COLLATE utf8_bin,
  `subfullgrade` float DEFAULT NULL,
  `subgrade` float DEFAULT NULL,
  `itemdemand` text COLLATE utf8_bin,
  `standardcode` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT '',
  `standardcontent` text COLLATE utf8_bin,
  `standardfullgrade` float DEFAULT NULL,
  `standardgrade` float DEFAULT NULL,
  `iscompliance` varchar(2) COLLATE utf8_bin DEFAULT NULL,
  `suggestion` text COLLATE utf8_bin,
  `sub_sysid` varchar(36) COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) DEFAULT '0',
  `isreported` varchar(2) COLLATE utf8_bin DEFAULT '0',
  `id` varchar(100) COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `tb_fxpg_assessment_list` */

DROP TABLE IF EXISTS `tb_fxpg_assessment_list`;

CREATE TABLE `tb_fxpg_assessment_list` (
  `batchno` varchar(36) COLLATE utf8_bin NOT NULL,
  `deptname` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `jsscore` float(9,4) DEFAULT NULL,
  `glscore` float(9,4) DEFAULT NULL,
  `taskno` varchar(36) COLLATE utf8_bin DEFAULT NULL,
  `sub_sysid` varchar(36) COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) DEFAULT '0',
  `isreported` varchar(2) COLLATE utf8_bin DEFAULT '0',
  PRIMARY KEY (`batchno`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `tb_fxpg_deletedtasks` */

DROP TABLE IF EXISTS `tb_fxpg_deletedtasks`;

CREATE TABLE `tb_fxpg_deletedtasks` (
  `taskid` varchar(100) NOT NULL,
  `isreported` varchar(100) DEFAULT '0',
  `sub_sysid` varchar(36) DEFAULT NULL,
  `sub_sysname` varchar(60) DEFAULT NULL,
  `stdorgid` varchar(100) DEFAULT NULL,
  `stdorgname` varchar(255) DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`taskid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_fxpg_objassess_task` */

DROP TABLE IF EXISTS `tb_fxpg_objassess_task`;

CREATE TABLE `tb_fxpg_objassess_task` (
  `taskno` varchar(36) COLLATE utf8_bin NOT NULL,
  `taskname` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `starttime` datetime DEFAULT NULL,
  `endtime` datetime DEFAULT NULL,
  `sub_sysid` varchar(36) COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) DEFAULT '0',
  `isreported` varchar(2) COLLATE utf8_bin DEFAULT '0',
  `id` varchar(100) COLLATE utf8_bin NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `tb_ga_media_info` */

DROP TABLE IF EXISTS `tb_ga_media_info`;

CREATE TABLE `tb_ga_media_info` (
  `id` varchar(100) NOT NULL COMMENT '介质信息ID',
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) DEFAULT NULL,
  `sn` varchar(300) NOT NULL COMMENT '介质序列号',
  `type` varchar(4) DEFAULT NULL COMMENT '介质类型:03双向交换盘 02单向导入盘 01内网专用盘',
  `typename` varchar(100) DEFAULT NULL,
  `state` varchar(4) DEFAULT NULL COMMENT '状态标志:01–正常 02–已注销 03-已强制注销',
  `statename` varchar(100) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL COMMENT '责任人名称',
  `deptname` text COMMENT '部门名称',
  `volume` varchar(50) DEFAULT NULL COMMENT '容量',
  `pid` varchar(100) DEFAULT NULL,
  `vid` varchar(100) DEFAULT NULL,
  `factoryname` text COMMENT '厂商',
  `unitname` text COMMENT '单位',
  `orgcode` varchar(50) DEFAULT NULL COMMENT '机构代码',
  `remark` text COMMENT '备注',
  `regdate` datetime NOT NULL COMMENT '注册时间',
  `unregdate` datetime DEFAULT NULL COMMENT '注销时间',
  `sub_sysid` varchar(36) DEFAULT NULL,
  `sub_sysname` varchar(60) DEFAULT NULL,
  `stdorgid` varchar(36) DEFAULT NULL,
  `stdorgname` varchar(255) DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  `oper_flag` varchar(2) DEFAULT 'i',
  PRIMARY KEY (`id`),
  KEY `SN_INDEX` (`sn`(255)),
  KEY `idx_dealflag` (`dealflag`),
  KEY `idx_year` (`year_info`),
  KEY `idx_regdate` (`regdate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_ga_mediainfo_log` */

DROP TABLE IF EXISTS `tb_ga_mediainfo_log`;

CREATE TABLE `tb_ga_mediainfo_log` (
  `id` varchar(100) NOT NULL COMMENT '日志ID',
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) DEFAULT NULL,
  `logtype` varchar(4) DEFAULT NULL COMMENT '日志类型',
  `logtypename` varchar(100) DEFAULT NULL,
  `deptname` text,
  `isviolation` varchar(10) DEFAULT NULL,
  `srcpath` text COMMENT '文件源路径',
  `destpath` text COMMENT '文件目标路径',
  `filename` text,
  `fileid` varchar(36) DEFAULT NULL,
  `computername` varchar(200) DEFAULT NULL COMMENT '计算机名称',
  `computerusername` varchar(150) DEFAULT NULL COMMENT '计算机用户',
  `hdid` varchar(100) DEFAULT NULL COMMENT '硬盘序列号',
  `hostip` varchar(100) DEFAULT NULL COMMENT 'IP地址',
  `mac` varchar(100) DEFAULT NULL COMMENT 'MAC地址',
  `filesize` varchar(50) DEFAULT NULL COMMENT '文件大小',
  `file_create_time` datetime DEFAULT NULL COMMENT '文件创建时间',
  `file_modify_time` datetime DEFAULT NULL COMMENT '文件修改时间',
  `inside_lan` int(11) DEFAULT '0' COMMENT '1代表内网，0代表外网',
  `lan_sign` text COMMENT '网络名的拼音缩写',
  `mediaid` varchar(100) DEFAULT NULL,
  `sn` varchar(300) DEFAULT NULL COMMENT '介质序列号',
  `factoryname` text COMMENT '介质厂商',
  `createdate` datetime DEFAULT NULL COMMENT '日志产生时间',
  `log_version` text COMMENT '日志结构版本',
  `reserve` text COMMENT '扩展存储',
  `type` varchar(4) DEFAULT NULL,
  `typename` varchar(100) DEFAULT NULL,
  `state` varchar(4) DEFAULT NULL,
  `statename` varchar(100) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `loglevel` varchar(10) DEFAULT NULL,
  `loglevelname` varchar(60) DEFAULT NULL,
  `sub_sysid` varchar(36) DEFAULT NULL,
  `sub_sysname` varchar(60) DEFAULT NULL,
  `stdorgid` varchar(36) DEFAULT NULL,
  `stdorgname` varchar(255) DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) DEFAULT '0',
  `sumflag` int(1) DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  `oper_flag` varchar(2) DEFAULT 'i',
  PRIMARY KEY (`id`),
  KEY `idx_year_info` (`year_info`),
  KEY `idx_dealflag` (`dealflag`),
  KEY `idx_stdorgid` (`stdorgid`),
  KEY `idx_sn` (`sn`),
  KEY `idx_fileid` (`fileid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_hostaudit_illegal` */

DROP TABLE IF EXISTS `tb_hostaudit_illegal`;

CREATE TABLE `tb_hostaudit_illegal` (
  `id` varchar(100) NOT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) DEFAULT NULL,
  `hostid` text,
  `hdid` text,
  `mac` text,
  `deptname` varchar(1000) DEFAULT NULL,
  `hostip` text,
  `username` varchar(20) DEFAULT NULL,
  `auditType` int(10) DEFAULT '0',
  `audittypename` varchar(40) DEFAULT NULL,
  `isViolation` varchar(20) DEFAULT '违规',
  `hostname` varchar(200) DEFAULT NULL,
  `object` varchar(60) DEFAULT NULL,
  `recorddate` datetime DEFAULT NULL,
  `details` text,
  `remark` varchar(500) DEFAULT NULL,
  `nodeid` varchar(400) DEFAULT NULL,
  `objectname` varchar(500) DEFAULT NULL,
  `producttype` varchar(10) DEFAULT NULL,
  `program` varchar(500) DEFAULT NULL,
  `facility` varchar(10) DEFAULT NULL,
  `result` varchar(10) DEFAULT NULL,
  `sub_sysid` varchar(36) DEFAULT NULL,
  `sub_sysname` varchar(60) DEFAULT NULL,
  `stdorgid` varchar(36) DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `sumflag` int(1) NOT NULL DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  `logicid` text,
  `oper_flag` varchar(2) DEFAULT 'i',
  `stdorgname` varchar(255) DEFAULT NULL,
  KEY `id` (`id`),
  KEY `recorddate` (`recorddate`),
  KEY `idx_condition` (`year_info`,`year_month_info`,`stdorgid`,`dealflag`,`sumflag`),
  KEY `idx_tb_hostaudit_illegal_logicid` (`logicid`(333))
) ENGINE=MyISAM DEFAULT CHARSET=utf8
/*!50100 PARTITION BY LINEAR HASH (YEAR(recorddate)*100+MONTH(recorddate))
PARTITIONS 12 */;

/*Table structure for table `tb_hostaudit_log` */

DROP TABLE IF EXISTS `tb_hostaudit_log`;

CREATE TABLE `tb_hostaudit_log` (
  `id` varchar(100) CHARACTER SET utf8 NOT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `hostid` text COLLATE utf8_bin,
  `hdid` text COLLATE utf8_bin,
  `mac` text COLLATE utf8_bin,
  `deptname` varchar(1000) CHARACTER SET utf8 DEFAULT NULL,
  `hostip` text COLLATE utf8_bin,
  `username` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `auditType` int(10) DEFAULT '0',
  `audittypename` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `hostname` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `program` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `facility` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `actionType` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `object` varchar(60) CHARACTER SET utf8 DEFAULT NULL,
  `recorddate` datetime DEFAULT NULL,
  `details` text COLLATE utf8_bin,
  `level` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `remark` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `nodeid` varchar(400) CHARACTER SET utf8 DEFAULT NULL,
  `objectname` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `result` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `eventtype` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `producttype` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `behaviourtype` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `reservation` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `sub_sysid` varchar(36) CHARACTER SET utf8 DEFAULT NULL,
  `sub_sysname` varchar(60) CHARACTER SET utf8 DEFAULT NULL,
  `stdorgid` varchar(36) CHARACTER SET utf8 DEFAULT NULL,
  `stdorgname` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `sumflag` int(1) NOT NULL DEFAULT '0',
  `isreported` varchar(2) COLLATE utf8_bin DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_dealflag` (`dealflag`,`sumflag`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `tb_media_action` */

DROP TABLE IF EXISTS `tb_media_action`;

CREATE TABLE `tb_media_action` (
  `actionid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `isviolation` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `year_month_info` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `hostid` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `hostip` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `hostname` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `deptname` varchar(1000) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `mediaid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `medianame` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `mediatype` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `mediatypename` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `musername` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `mdeptname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `actiontype` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `actiontypename` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '插入介质 移除介质',
  `actiondate` datetime DEFAULT NULL,
  `loglevel` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `loglevelname` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `nodeid` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `IsReported` int(11) DEFAULT '0',
  PRIMARY KEY (`actionid`),
  KEY `idx_actiondate` (`actiondate`),
  KEY `idx_year` (`year_info`),
  KEY `idx_dealflag` (`dealflag`),
  KEY `idx_orgid` (`stdorgid`),
  KEY `idx_mediaid` (`mediaid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_media_files` */

DROP TABLE IF EXISTS `tb_media_files`;

CREATE TABLE `tb_media_files` (
  `id` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `actionid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `actionType` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '1 创建文件\n2 移动文件\n7 重命名文件\n3 复制文件\n4 删除文件\n5 创建目录\n6 删除目录\n8 格式化',
  `actiontypename` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `processPath` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `deptname` varchar(1000) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `filename` varchar(500) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `srcPath` varchar(500) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `destPath` varchar(500) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `loglinkto` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `loglevel` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `loglevelname` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `fileid` varchar(36) COLLATE latin1_general_cs DEFAULT '0',
  `dealflag` varchar(1) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `IsReported` int(11) DEFAULT '0',
  `sumflag` int(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_createdate` (`createdate`),
  KEY `idx_year` (`year_info`),
  KEY `idx_dealflag` (`dealflag`,`sumflag`),
  KEY `idx_filename` (`filename`(255)),
  KEY `idx_fileid` (`fileid`),
  KEY `idx_actionid` (`actionid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_cs;

/*Table structure for table `tb_media_info` */

DROP TABLE IF EXISTS `tb_media_info`;

CREATE TABLE `tb_media_info` (
  `mediaid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sn` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `medianname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `mediatype` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `mediatypename` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `mediastate` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `mediastatename` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `seclevel` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `seclevelname` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `pid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `vid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `deptname` varchar(1000) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `regdate` datetime DEFAULT NULL,
  `unregdate` datetime DEFAULT NULL,
  `sub_sysid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  `oper_flag` varchar(2) DEFAULT 'i',
  PRIMARY KEY (`mediaid`),
  KEY `idx_regdate` (`regdate`),
  KEY `idx_year` (`year_info`),
  KEY `idx_dealflag` (`dealflag`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_mg_org` */

DROP TABLE IF EXISTS `tb_mg_org`;

CREATE TABLE `tb_mg_org` (
  `id` varchar(36) COLLATE utf8_bin NOT NULL,
  `name` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `parentid` varchar(36) COLLATE utf8_bin DEFAULT NULL,
  `orders` int(11) DEFAULT '0',
  `region` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `flag` int(11) DEFAULT '0',
  `createdate` datetime DEFAULT NULL,
  `sub_sysid` varchar(1000) COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(36) COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) DEFAULT '0',
  `isreported` varchar(2) COLLATE utf8_bin DEFAULT '0',
  `reportflag` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `NewIndex1` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `tb_mg_org_report` */

DROP TABLE IF EXISTS `tb_mg_org_report`;

CREATE TABLE `tb_mg_org_report` (
  `orgid` varchar(36) COLLATE utf8_bin NOT NULL,
  `reportcount` int(11) DEFAULT '0',
  `recordcount` int(11) DEFAULT '0',
  `createdate` datetime DEFAULT NULL,
  `sub_sysid` varchar(1000) COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(36) COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) DEFAULT '0',
  `isreported` varchar(2) COLLATE utf8_bin DEFAULT '0',
  `flag` int(11) DEFAULT '0',
  PRIMARY KEY (`orgid`),
  KEY `idx_orgid` (`orgid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `tb_mg_sensitive_info` */

DROP TABLE IF EXISTS `tb_mg_sensitive_info`;

CREATE TABLE `tb_mg_sensitive_info` (
  `id` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `filecode` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `name` text,
  `summary` text CHARACTER SET utf8 COLLATE utf8_bin,
  `keyword` text CHARACTER SET utf8 COLLATE utf8_bin,
  `srclocation` text CHARACTER SET utf8 COLLATE utf8_bin,
  `destlocation` text CHARACTER SET utf8 COLLATE utf8_bin,
  `action` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `actionname` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `feature` varchar(500) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `computername` text,
  `hdid` text,
  `hostip` text,
  `mac` text,
  `computerlocation` text,
  `username` varchar(40) DEFAULT NULL,
  `authname` varchar(40) DEFAULT NULL,
  `entrystamp` datetime DEFAULT NULL,
  `dealdate` datetime DEFAULT NULL,
  `deptname` varchar(1000) DEFAULT NULL,
  `sub_sysid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `mglevel` varchar(2) DEFAULT NULL,
  `mglevelname` varchar(100) DEFAULT NULL,
  `isreported` varchar(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_logdate` (`entrystamp`),
  KEY `idx_year` (`year_info`),
  KEY `idx_dealflag` (`dealflag`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_nac_node` */

DROP TABLE IF EXISTS `tb_nac_node`;

CREATE TABLE `tb_nac_node` (
  `id` varchar(36) DEFAULT NULL,
  `mac` text,
  `computer` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `checkdate` datetime DEFAULT NULL,
  `regdate` datetime DEFAULT NULL,
  `unregdate` datetime DEFAULT NULL,
  `status` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `statusname` varchar(100) DEFAULT NULL,
  `online` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `onlinename` varchar(50) DEFAULT NULL,
  `deptname` varchar(1000) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `sumflag` int(1) NOT NULL DEFAULT '0',
  `insertflag` int(1) NOT NULL DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  `oper_flag` varchar(2) DEFAULT 'i',
  KEY `id` (`id`),
  KEY `idx_dealflag` (`dealflag`),
  KEY `idx_sumflag` (`sumflag`),
  KEY `idx_insertflag` (`insertflag`)
) ENGINE=MyISAM AUTO_INCREMENT=100000000003359 DEFAULT CHARSET=utf8 CHECKSUM=1 DELAY_KEY_WRITE=1 ROW_FORMAT=DYNAMIC;

/*Table structure for table `tb_nac_node_check` */

DROP TABLE IF EXISTS `tb_nac_node_check`;

CREATE TABLE `tb_nac_node_check` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `checkid` varchar(100) NOT NULL,
  `mac` text,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `computer` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `checkdate` datetime DEFAULT NULL,
  `logdate` date DEFAULT NULL,
  `checkpolicyname` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `checkItem` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `checkitemname` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `itemresult` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `itemresultname` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `result` varchar(2) DEFAULT NULL,
  `resultname` varchar(20) DEFAULT NULL,
  `remark` text,
  `iskeyitem` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `iskeyitemname` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `deptname` varchar(1000) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `sumflag` int(1) NOT NULL DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  KEY `id` (`id`),
  KEY `idx_dealflag` (`dealflag`)
) ENGINE=MyISAM AUTO_INCREMENT=174829 DEFAULT CHARSET=utf8;

/*Table structure for table `tb_nac_node_health` */

DROP TABLE IF EXISTS `tb_nac_node_health`;

CREATE TABLE `tb_nac_node_health` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) DEFAULT NULL,
  `allnum` int(11) DEFAULT '0',
  `passnum` int(11) DEFAULT '0',
  `notpassnum` int(11) DEFAULT '0',
  `health` decimal(10,0) DEFAULT '0',
  `logdate` date DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `stdorgid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `isreported` varchar(2) DEFAULT '0',
  KEY `id` (`id`),
  KEY `idx_year_month_info` (`year_month_info`),
  KEY `idx_logdate` (`logdate`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

/*Table structure for table `tb_netcheck_notcheck` */

DROP TABLE IF EXISTS `tb_netcheck_notcheck`;

CREATE TABLE `tb_netcheck_notcheck` (
  `id` int(36) NOT NULL AUTO_INCREMENT,
  `unitname` varchar(60) DEFAULT NULL,
  `deptname` varchar(1000) DEFAULT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `ownerid` varchar(50) DEFAULT NULL,
  `ownername` varchar(100) DEFAULT NULL,
  `hostid` text,
  `hostname` varchar(60) DEFAULT NULL,
  `hdid` text,
  `mboard` varchar(60) DEFAULT NULL,
  `ip` text,
  `mac` text,
  `impdate` datetime DEFAULT NULL,
  `sub_sysid` varchar(36) DEFAULT NULL,
  `sub_sysname` varchar(60) DEFAULT NULL,
  `stdunitid` varchar(36) DEFAULT NULL,
  `stdorgid` varchar(36) DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  `oper_flag` varchar(2) DEFAULT 'i',
  `logicid` text,
  `stdorgname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_year` (`year_info`),
  KEY `idx_month` (`month_info`),
  KEY `idx_dealflag` (`dealflag`),
  KEY `idx_tb_netcheck_notcheck_logicid` (`logicid`(333))
) ENGINE=MyISAM AUTO_INCREMENT=3788 DEFAULT CHARSET=utf8;

/*Table structure for table `tb_netcheck_result` */

DROP TABLE IF EXISTS `tb_netcheck_result`;

CREATE TABLE `tb_netcheck_result` (
  `id` varchar(100) NOT NULL,
  `unitid` varchar(36) DEFAULT NULL,
  `unitname` varchar(60) DEFAULT NULL,
  `batchno` varchar(36) DEFAULT NULL,
  `deptname` varchar(1000) DEFAULT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) DEFAULT NULL,
  `hostid` text,
  `hostname` varchar(200) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `office` varchar(10) DEFAULT NULL,
  `ownerid` varchar(100) DEFAULT NULL,
  `ownername` varchar(10) DEFAULT NULL,
  `seclevel` varchar(10) DEFAULT NULL,
  `createDate` date DEFAULT NULL,
  `checkItem` varchar(36) DEFAULT NULL,
  `checkItem_name` varchar(60) DEFAULT NULL,
  `isViolation` varchar(20) DEFAULT NULL,
  `violationlevel` varchar(10) DEFAULT NULL,
  `violationdesc` varchar(500) DEFAULT NULL,
  `hdid` text,
  `mboard` varchar(60) DEFAULT NULL,
  `ip` text,
  `mac` text,
  `impdate` datetime DEFAULT NULL,
  `program` varchar(500) DEFAULT NULL,
  `sub_sysid` varchar(36) DEFAULT NULL,
  `sub_sysname` varchar(60) DEFAULT NULL,
  `stdunitid` varchar(36) DEFAULT NULL,
  `stdorgid` varchar(36) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  `oper_flag` varchar(2) DEFAULT 'i',
  `stdorgname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_createdate` (`createDate`),
  KEY `idx_year` (`year_info`),
  KEY `idx_dealflag` (`dealflag`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_netcheck_selfcheck` */

DROP TABLE IF EXISTS `tb_netcheck_selfcheck`;

CREATE TABLE `tb_netcheck_selfcheck` (
  `id` varchar(100) NOT NULL DEFAULT '',
  `batchno` varchar(36) DEFAULT NULL,
  `unitname` varchar(60) DEFAULT NULL,
  `deptname` varchar(1000) DEFAULT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `office` varchar(10) DEFAULT NULL,
  `ownerid` varchar(10) DEFAULT NULL,
  `ownername` varchar(100) DEFAULT NULL,
  `isself` varchar(10) DEFAULT NULL,
  `hostid` text,
  `hostname` varchar(200) DEFAULT NULL,
  `checkdate` datetime DEFAULT NULL,
  `hdid` text,
  `mboard` varchar(200) DEFAULT NULL,
  `ip` text,
  `mac` text,
  `impdate` datetime DEFAULT NULL,
  `program` varchar(255) DEFAULT NULL,
  `checkcount` int(11) DEFAULT '0' COMMENT '检查次数',
  `sub_sysid` varchar(36) DEFAULT NULL,
  `sub_sysname` varchar(60) DEFAULT NULL,
  `stdunitid` varchar(36) DEFAULT NULL,
  `stdorgid` varchar(36) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  `oper_flag` varchar(2) DEFAULT 'i',
  `logicid` text,
  `stdorgname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_checkdate` (`checkdate`),
  KEY `idx_year` (`year_info`),
  KEY `idx_dealflag` (`dealflag`),
  KEY `idx_tb_netcheck_selfcheck_logicid` (`logicid`(333))
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_network_alarm` */

DROP TABLE IF EXISTS `tb_network_alarm`;

CREATE TABLE `tb_network_alarm` (
  `id` varchar(100) NOT NULL,
  `sitename` varchar(100) DEFAULT NULL,
  `siteurl` varchar(100) DEFAULT NULL,
  `siteid` varchar(36) DEFAULT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `keyword` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `year_month_info` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `proofnum` int(11) DEFAULT '0',
  `logdate` datetime DEFAULT NULL,
  `urlhash` varchar(200) DEFAULT NULL,
  `sub_sysid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `systype` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `sumflag` int(1) DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  `oper_flag` varchar(2) DEFAULT 'i',
  KEY `id` (`id`),
  KEY `idx_year` (`year_info`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_network_control` */

DROP TABLE IF EXISTS `tb_network_control`;

CREATE TABLE `tb_network_control` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sitename` varchar(500) DEFAULT NULL,
  `siteurl` varchar(200) DEFAULT NULL,
  `siteid` varchar(36) DEFAULT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `alarmnum` int(11) DEFAULT '0',
  `suspicionnum` int(11) DEFAULT '0',
  `attentionnum` int(11) DEFAULT '0',
  `proofnum` int(11) DEFAULT '0',
  `urlhash` varchar(200) DEFAULT NULL,
  `logdate` datetime DEFAULT NULL,
  `sub_sysid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `systype` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '07',
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `sumflag` int(1) DEFAULT '0',
  `insertflag` int(1) DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  `oper_flag` varchar(2) DEFAULT 'i',
  `stdorgid` varchar(36) DEFAULT NULL,
  `stdorgname` varchar(255) DEFAULT NULL,
  KEY `id` (`id`),
  KEY `idx_year` (`year_info`),
  KEY `idx_year_month` (`year_month_info`),
  KEY `idx_dealflag` (`dealflag`),
  KEY `idx_sumflag` (`sumflag`),
  KEY `idx_insertflag` (`insertflag`),
  KEY `idx_proof` (`proofnum`)
) ENGINE=MyISAM AUTO_INCREMENT=14622 DEFAULT CHARSET=utf8;

/*Table structure for table `tb_network_control_result` */

DROP TABLE IF EXISTS `tb_network_control_result`;

CREATE TABLE `tb_network_control_result` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sitename` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `siteurl` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `siteid` varchar(36) CHARACTER SET utf8 DEFAULT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) COLLATE utf8_bin DEFAULT NULL,
  `alarmnum` int(11) DEFAULT '0',
  `suspicionnum` int(11) DEFAULT '0',
  `attentionnum` int(11) DEFAULT '0',
  `proofnum` int(11) DEFAULT '0',
  `sub_sysid` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `systype` varchar(10) COLLATE utf8_bin DEFAULT '07',
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `sumflag` int(1) DEFAULT '0',
  `isreported` varchar(2) COLLATE utf8_bin DEFAULT '0',
  `oper_flag` varchar(2) COLLATE utf8_bin DEFAULT 'i',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx` (`id`),
  KEY `idx_year` (`year_info`),
  KEY `idx_year_month_info` (`year_month_info`),
  KEY `idx_dealflag` (`dealflag`),
  KEY `idx_sumflag` (`sumflag`),
  KEY `idx_siteid` (`siteid`)
) ENGINE=MyISAM AUTO_INCREMENT=14622 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `tb_network_site` */

DROP TABLE IF EXISTS `tb_network_site`;

CREATE TABLE `tb_network_site` (
  `id` varchar(100) NOT NULL,
  `sitename` varchar(500) DEFAULT NULL,
  `siteurl` varchar(200) DEFAULT NULL,
  `sub_sysid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `systype` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `isreported` varchar(2) DEFAULT '0',
  `oper_flag` varchar(2) DEFAULT 'i',
  KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_onewayinput_log` */

DROP TABLE IF EXISTS `tb_onewayinput_log`;

CREATE TABLE `tb_onewayinput_log` (
  `id` varchar(36) COLLATE utf8_bin NOT NULL,
  `filename` varchar(512) COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `acttime` datetime DEFAULT NULL,
  `result` varchar(512) COLLATE utf8_bin DEFAULT NULL,
  `sub_sysid` varchar(36) COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `isreported` varchar(2) COLLATE utf8_bin DEFAULT '0',
  `devid` varchar(200) COLLATE utf8_bin DEFAULT NULL,
  `devname` varchar(400) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `tb_print_log` */

DROP TABLE IF EXISTS `tb_print_log`;

CREATE TABLE `tb_print_log` (
  `id` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `deptname` varchar(1000) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `hostname` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `hostip` text,
  `hostid` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `hdid` text,
  `isViolation` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `mac` text,
  `filename` varchar(1000) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `filetype` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `beginDate` datetime DEFAULT NULL,
  `endDate` datetime DEFAULT NULL,
  `printerName` varchar(500) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `pagenum` int(11) DEFAULT '0',
  `copies` int(11) DEFAULT '0',
  `printstate` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `printstatename` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `seclevel` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `seclevelname` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `IsSensitivity` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `IsSensitivityname` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `isSide` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `issidename` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `isImg` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `pageSize` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `iscolor` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `SensitivityContent` varchar(800) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `dirdocname` varchar(1000) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `delCopies` int(11) DEFAULT '0',
  `endDelcopies` int(11) DEFAULT '0',
  `direction` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `iscallback` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `iscallbackname` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `excuse` varchar(500) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `auditname` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `accName` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `infofrom` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `logtype` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `fileid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '0',
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `sumflag` int(1) DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_year` (`year_info`),
  KEY `idx_filename` (`filename`(255)),
  KEY `idx_dealflag` (`dealflag`,`sumflag`),
  KEY `idx_fileid` (`fileid`),
  KEY `idx_createdate` (`beginDate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_register` */

DROP TABLE IF EXISTS `tb_register`;

CREATE TABLE `tb_register` (
  `sysCode` varchar(36) NOT NULL,
  `sysname` varchar(60) DEFAULT NULL,
  `shortname` varchar(60) DEFAULT NULL,
  `sysIp` varchar(20) DEFAULT NULL,
  `domainName` varchar(60) DEFAULT NULL,
  `authCode` varchar(255) DEFAULT NULL,
  `platform` varchar(60) DEFAULT NULL,
  `producer` varchar(60) DEFAULT NULL,
  `isencrypt` varchar(2) DEFAULT NULL,
  `encryptmodel` varchar(20) DEFAULT NULL,
  `systype` varchar(20) DEFAULT NULL,
  `creator` varchar(20) DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  `addTime` datetime DEFAULT NULL,
  `operator` varchar(20) DEFAULT NULL,
  `lasttime` datetime DEFAULT NULL,
  `linkto` varchar(120) DEFAULT NULL,
  `valid` varchar(2) DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `isreported` varchar(2) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `tb_safelogin_key_event` */

DROP TABLE IF EXISTS `tb_safelogin_key_event`;

CREATE TABLE `tb_safelogin_key_event` (
  `id` varchar(100) COLLATE utf8_bin NOT NULL,
  `key_info` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `op_type` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `op_time` datetime DEFAULT NULL,
  `host_name` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `dept_name` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `user_name` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `logon_user` varchar(150) COLLATE utf8_bin DEFAULT NULL,
  `host_ip` text COLLATE utf8_bin,
  `host_id` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `sub_sysid` varchar(36) COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `isreported` varchar(2) COLLATE utf8_bin DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Table structure for table `tb_safetydisk_info` */

DROP TABLE IF EXISTS `tb_safetydisk_info`;

CREATE TABLE `tb_safetydisk_info` (
  `disksn` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `scope` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `diskstate` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `unitname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `deptname` varchar(1000) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `ProducerID` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `pid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `vid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `regdate` datetime DEFAULT NULL,
  `unregdate` datetime DEFAULT NULL,
  `sub_sysid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  `oper_flag` varchar(2) DEFAULT 'i',
  PRIMARY KEY (`disksn`),
  KEY `disksn` (`disksn`),
  KEY `idx_year` (`year_info`),
  KEY `idx_regdate` (`regdate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_safetydisk_operate_log` */

DROP TABLE IF EXISTS `tb_safetydisk_operate_log`;

CREATE TABLE `tb_safetydisk_operate_log` (
  `id` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `disksn` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `actionType` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `actiontypename` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `scope` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `hostid` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `hdid` text,
  `hostip` text,
  `hostname` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `unitname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `deptname` varchar(1000) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `disk_username` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `processPath` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `filename` varchar(500) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `srcPath` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `destPath` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `sub_sysid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgname` varchar(255) DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `fileid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '0',
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `sumflag` int(1) DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_createdate` (`createdate`),
  KEY `idx_year` (`year_info`),
  KEY `idx_dealflag` (`dealflag`,`sumflag`),
  KEY `idx_fileid` (`fileid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_safetydisk_use_log` */

DROP TABLE IF EXISTS `tb_safetydisk_use_log`;

CREATE TABLE `tb_safetydisk_use_log` (
  `actionid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `year_info` int(11) DEFAULT '0',
  `month_info` int(11) DEFAULT '0',
  `year_month_info` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `disksn` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `diskmodel` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `scope` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `hostid` varchar(40) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `hdid` text,
  `isViolation` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `hostip` text,
  `hostname` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `unitname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `deptname` varchar(1000) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `username` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `disk_username` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `actiontype` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `actiondate` datetime DEFAULT NULL,
  `loginState` varchar(10) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `ProducerID` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `loginDate` datetime DEFAULT NULL,
  `sub_sysid` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `sub_sysname` varchar(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `stdorgid` varchar(36) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` varchar(1) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `isreported` varchar(2) DEFAULT '0',
  PRIMARY KEY (`actionid`),
  KEY `idx_actiondate` (`actiondate`),
  KEY `idx_year` (`year_info`),
  KEY `idx_dealflag` (`dealflag`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Table structure for table `tb_seclogon_key` */

DROP TABLE IF EXISTS `tb_seclogon_key`;

CREATE TABLE `tb_seclogon_key` (
  `key_sn` varchar(50) NOT NULL,
  `remark` text,
  `create_time` varchar(30) DEFAULT NULL,
  `sub_sysid` varchar(36) DEFAULT NULL,
  `sub_sysname` varchar(60) DEFAULT NULL,
  `stdorgid` varchar(36) DEFAULT NULL,
  `stdorgname` varchar(255) DEFAULT NULL,
  `impdate` datetime DEFAULT NULL,
  `dealflag` int(1) NOT NULL DEFAULT '0',
  `sumflag` int(1) NOT NULL DEFAULT '0',
  `oper_flag` varchar(2) DEFAULT 'i',
  `isreported` varchar(2) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '0',
  PRIMARY KEY (`key_sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
