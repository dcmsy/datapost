# datapost （数据采集上报端）
数据采集上报端
# 概述
	本应用提供数据采集功能，通过采集接口可以将多种数据源的数据导入到中间库，为数据分析评估提供源数据。
	通过配置xml文件，可快速与第三方厂家数据集成，无需改动代码。
	提供配置界面，用于配置上报的平台、数据库IP、端口、用户名、密码及中间库参数。
	核心功能代码与数据采集sql语句分离，便于统一管理与优化，解除sql与程序代码的耦合。
	
# 功能
	1.支持异构服务升级，本身应用的持续升级功能；
	2.集成beego，实现配置界面化；
	3.自动检测并创建数据传输标志位；
	4.支持定时任务或实时上报任务；
	5.支持日志数据和基础主数据上报；
	6.根据系统表中的行数变化，决定是否执行数据上报；
	7.可对接多种数据库类型。
	
# 运行方式
	1.注册为windows后台服务；
	2.建立交叉编译环境后，也可运行与linux系统中。
	
# 传输方式
 1.中间库方式；
 2.https加密传输；

# 支持的数据库类型
 1.mysql；
 2.mssql；
 3.mongodb；
 通过配置ini的类型，支持其他数据库类型。
 
# 管理端访问地址
  上报端（业务库到中间库 datapost）：http:127.0.0.1:8880/
  接收端（中间库到目标库 receive） ：http:127.0.0.1:8890/
  
# https数据提交api
  https://127.0.0.1:8881/api/nettrans/put 
  
# 所用语言
  go
  版本 1.5

# 已知问题
 1.
SQL Server 2008 and 2008 R2 engine cannot handle login records when SSL encryption is not disabled. To fix SQL Server 2008 R2 issue, install SQL Server 2008 R2 Service 

Pack 2. To fix SQL Server 2008 issue, install Microsoft SQL Server 2008 Service Pack 3 and Cumulative update package 3 for SQL Server 2008 SP3. More information: 

http://support.microsoft.com/kb/2653857

  servicepack2：https://www.microsoft.com/zh-cn/download/details.aspx?id=30437
  servicepack3：https://www.microsoft.com/en-us/download/details.aspx?id=44271
2.
TLS Handshake failed: tls: failed to parse certificate from server: x509: negative serial number
 
If there is no installed certificates, every time that the SQL Server restarts, it creates a self signed certificate.
If the SQL Server runs on Windows Server 2003 try this hotfix: http://support.microsoft.com/KB/945344
If not try to restart the SQL Server process.

    32bit：333422_CHS_i386_zip.exe
    64bit：344 1_CHS_x64_zip.exe

 
