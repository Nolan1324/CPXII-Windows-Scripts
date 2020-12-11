@echo off
SETLOCAL

SET /P RDP=Is RDP a critical service? ([Y]/N)
IF /I "%RDP%" NEQ "N" GOTO AFTERRDP

CALL :Disable "RasAuto"
CALL :Disable "SessionEnv"
CALL :Disable "TermService"
CALL :Disable "UmRdpService"
CALL :Disable "RpcLocator"
CALL :Disable "RemoteAccess"
CALL :Disable "WinRM"
CALL :Disable "RasMan"

:AFTERRDP
SET /P RDP=Is this Windows Server? ([Y]/N)
IF /I "%RDP%" NEQ "N" GOTO AFTERSERVER

:AFTERSERVER
CALL :Disable "BTAGService"
CALL :Disable "bthserv"
CALL :Disable "Browser"
CALL :Disable "MapsBroker"
CALL :Disable "lfsvc"
CALL :Disable "irmon"
CALL :Disable "SharedAccess"
CALL :Disable "lltdsvc"
CALL :Disable "LxssManager"
CALL :Disable "FTPSVC"
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
