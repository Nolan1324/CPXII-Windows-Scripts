@echo off
SETLOCAL

:RDPService
set /p rdpChk="Is RDP a critical service (y/n)"
if %rdpChk%==y (
	CALL :Enable "RasAuto"
    CALL :Enable "SessionEnv"
    CALL :Enable "TermService"
    CALL :Enable "UmRdpService"
    CALL :Enable "RpcLocator"
    CALL :Enable "RemoteAccess"
    CALL :Enable "WinRM"
    CALL :Enable "RasMan"
	goto:FTPService
)
if %rdpChk%==n (
	CALL :Disable "RasAuto"
    CALL :Disable "SessionEnv"
    CALL :Disable "TermService"
    CALL :Disable "UmRdpService"
    CALL :Disable "RpcLocator"
    CALL :Disable "RemoteAccess"
    CALL :Disable "WinRM"
    CALL :Disable "RasMan
    goto:FTPService
)
goto:RDPService

:FTPService
set /p ftpChk="Is FTP a critical service (y/n)"
if %ftpChk%==y (
	CALL :Enable "FTPSVC"
	goto:AFTERFTP
)
if %ftpChk%==n (
	CALL :Disable "FTPSVC"
	goto:AFTERFTP
)
goto:FTPService

:AFTERFTP
CALL :Disable "BTAGService"
CALL :Disable "bthserv"
CALL :Disable "Browser"
CALL :Disable "MapsBroker"
CALL :Disable "lfsvc"
CALL :Disable "irmon"
CALL :Disable "SharedAccess"
CALL :Disable "lltdsvc"
CALL :Disable "LxssManager"
CALL :Disable "MSiSCSI"
CALL :Disable "InstallService"
CALL :Disable "sshd"
CALL :Disable "PNRPsvc"
CALL :Disable "p2psvc"
CALL :Disable "p2pimsvc"
CALL :Disable "PNRPAutoReg"
CALL :Disable "wercplsupport"
CALL :Disable "RemoteRegistry"
CALL :Disable "simptcp"
CALL :Disable "SNMP"
CALL :Disable "SSDPSRV"
CALL :Disable "upnphost"
CALL :Disable "WMSvc"
CALL :Disable "WerSvc"
CALL :Disable "WMPNetworkSvc"
CALL :Disable "icssvc"
CALL :Disable "PushToInstall"
CALL :Disable "XboxGipSvc"
CALL :Disable "XblAuthManager"
CALL :Disable "XblGameSave"
CALL :Disable "XboxNetApiSvc"
CALL :Disable "WebClient"
CALL :Disable "IISADMIN"
CALL :Disable "LanmanServer"
CALL :Disable "W3SVC"
CALL :Disable "iphlpsvc"
CALL :Disable "iprip"
CALL :Disable "Spooler"
CALL :Disable "LanmanServer"
CALL :Disable "SNMPTRAP"
CALL :Disable "lmhosts"
CALL :Disable "TapiSvc"

REM Enable core services
CALL :Enable "EventLog"
CALL :Enable "wuauserv"
CALL :Enable "mpssvc"
CALL :Enable "WinDefend"
Call :Enable "WdNisSvc"
Call :Enable "Sense"
Call :Enable "Dhcp"
Call :Enable "Dnscache"
Call :Enable "NtLmSsp"

pause
EXIT /B %ERRORLEVEL%

:Disable
sc config %~1 start= disabled
sc stop %~1
EXIT /B 0

:Enable
sc config %~1 start= auto
sc start %~1
EXIT /B 0
