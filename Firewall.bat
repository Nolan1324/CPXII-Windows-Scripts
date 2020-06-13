@echo off

netsh advfirewall set allprofiles state on
netsh advfirewall firewall add rule name="!CyberPatriotTCPOut" protocol=TCP dir=out remoteport=23,161,162,411,412,636,3269 action=block
netsh advfirewall firewall add rule name="!CyberPatriotTCPIn" protocol=TCP dir=in remoteport=23,161,162,411,412,636,3269 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPOut" protocol=UDP dir=out remoteport=23,161,162,411,412,636,3269 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPIn" protocol=UDP dir=in remoteport=23,161,162,411,412,636,3269 action=block

set /p ftpChk="Is FTP a critical service? (y/n)"
if %ftpChk%==y ( 
netsh advfirewall firewall add rule name="!CyberPatriotTCPOut" protocol=TCP dir=out remoteport=20,21 action=block
netsh advfirewall firewall add rule name="!CyberPatriotTCPIn" protocol=TCP dir=in remoteport=20,21 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPOut" protocol=UDP dir=out remoteport=20,21 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPIn" protocol=UDP dir=in remoteport=20,21 action=block
)

else (
netsh advfirewall firewall add rule name="!CyberPatriotTCPOut" protocol=TCP dir=out remoteport=20,21 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotTCPIn" protocol=TCP dir=in remoteport=20,21 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotUDPOut" protocol=UDP dir=out remoteport=20,21 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotUDPIn" protocol=UDP dir=in remoteport=20,21 action=allow
)

set /p sshChk="Is SSH a critical service? (y/n)"
if %sshChk%==y ( 
netsh advfirewall firewall add rule name="!CyberPatriotTCPOut" protocol=TCP dir=out remoteport=22 action=block
netsh advfirewall firewall add rule name="!CyberPatriotTCPIn" protocol=TCP dir=in remoteport=22 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPOut" protocol=UDP dir=out remoteport=22 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPIn" protocol=UDP dir=in remoteport=22 action=block
)

else (
netsh advfirewall firewall add rule name="!CyberPatriotTCPOut" protocol=TCP dir=out remoteport=22 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotTCPIn" protocol=TCP dir=in remoteport=22 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotUDPOut" protocol=UDP dir=out remoteport=22 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotUDPIn" protocol=UDP dir=in remoteport=22 action=allow
)

set /p rdpChk="Is RDP a critical service? (y/n)"
if %rdpChk%==y ( 
netsh advfirewall firewall add rule name="!CyberPatriotTCPOut" protocol=TCP dir=out remoteport=135 action=block
netsh advfirewall firewall add rule name="!CyberPatriotTCPIn" protocol=TCP dir=in remoteport=135 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPOut" protocol=UDP dir=out remoteport=135 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPIn" protocol=UDP dir=in remoteport=135 action=block
)

else (
netsh advfirewall firewall add rule name="!CyberPatriotTCPOut" protocol=TCP dir=out remoteport=135 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotTCPIn" protocol=TCP dir=in remoteport=135 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotUDPOut" protocol=UDP dir=out remoteport=135 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotUDPIn" protocol=UDP dir=in remoteport=135 action=allow
)

pause
