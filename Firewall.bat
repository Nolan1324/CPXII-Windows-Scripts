@echo off

netsh advfirewall reset
netsh advfirewall set allprofiles state on
netsh advfirewall firewall add rule name="!CyberPatriotTCPOut" protocol=TCP dir=out remoteport=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,23,37,53,69,79,87,109,110,111,119,123,137,138,139,143,161,162,179,389,411,412,445,512,513,514,515,540,636,1080,2000,2001,2049,3269,4001,4045,6001,8000,8080,8888 action=block
netsh advfirewall firewall add rule name="!CyberPatriotTCPIn" protocol=TCP dir=in remoteport=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,23,37,53,69,79,87,109,110,111,119,123,137,138,139,143,161,162,179,389,411,412,445,512,513,514,515,540,636,1080,2000,2001,2049,3269,4001,4045,6001,8000,8080,8888 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPOut" protocol=UDP dir=out remoteport=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,23,37,53,69,79,87,109,110,111,119,123,137,138,139,143,161,162,179,389,411,412,445,512,513,514,515,540,636,1080,2000,2001,2049,3269,4001,4045,6001,8000,8080,8888 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPIn" protocol=UDP dir=in remoteport=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,23,37,53,69,79,87,109,110,111,119,123,137,138,139,143,161,162,179,389,411,412,445,512,513,514,515,540,636,1080,2000,2001,2049,3269,4001,4045,6001,8000,8080,8888 action=block

set /p ftpChk="Is FTP a critical service? (y/n)"
if %ftpChk%==y ( 
netsh advfirewall firewall add rule name="!CyberPatriotTCPOutFTPAllow" protocol=TCP dir=out remoteport=20,21 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotTCPInFTPAllow" protocol=TCP dir=in remoteport=20,21 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotUDPOutFTPAllow" protocol=UDP dir=out remoteport=20,21 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotUDPInFTPAllow" protocol=UDP dir=in remoteport=20,21 action=allow
)

if %ftpChk%==n (
netsh advfirewall firewall add rule name="!CyberPatriotTCPOutFTPBlock" protocol=TCP dir=out remoteport=20,21 action=block
netsh advfirewall firewall add rule name="!CyberPatriotTCPInFTPBlock" protocol=TCP dir=in remoteport=20,21 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPOutFTPBlock" protocol=UDP dir=out remoteport=20,21 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPInFTPBlock" protocol=UDP dir=in remoteport=20,21 action=block
)

set /p sshChk="Is SSH a critical service? (y/n)"
if %sshChk%==y ( 
netsh advfirewall firewall add rule name="!CyberPatriotTCPOutSSHAllow" protocol=TCP dir=out remoteport=22 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotTCPInSSHAllow" protocol=TCP dir=in remoteport=22 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotUDPOutSSHAllow" protocol=UDP dir=out remoteport=22 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotUDPInSSHAllow" protocol=UDP dir=in remoteport=22 action=allow
)

if %sshChk%==n (
netsh advfirewall firewall add rule name="!CyberPatriotTCPOutSSHBlock" protocol=TCP dir=out remoteport=22 action=block
netsh advfirewall firewall add rule name="!CyberPatriotTCPInSSHBlock" protocol=TCP dir=in remoteport=22 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPOutSSHBlock" protocol=UDP dir=out remoteport=22 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPInSSHBlock" protocol=UDP dir=in remoteport=22 action=block
)

set /p rdpChk="Is RDP a critical service? (y/n)"
if %rdpChk%==y ( 
netsh advfirewall firewall add rule name="!CyberPatriotTCPOutRDPAllow" protocol=TCP dir=out remoteport=135 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotTCPInRDPAllow" protocol=TCP dir=in remoteport=135 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotUDPOutRDPAllow" protocol=UDP dir=out remoteport=135 action=allow
netsh advfirewall firewall add rule name="!CyberPatriotUDPInRDPAllow" protocol=UDP dir=in remoteport=135 action=allow
)

if %rdpChk%==n (
netsh advfirewall firewall add rule name="!CyberPatriotTCPOutRDPBlock" protocol=TCP dir=out remoteport=135 action=block
netsh advfirewall firewall add rule name="!CyberPatriotTCPInRDPBlock" protocol=TCP dir=in remoteport=135 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPOutRDPBlock" protocol=UDP dir=out remoteport=135 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPInRDPBlock" protocol=UDP dir=in remoteport=135 action=block
)

pause
