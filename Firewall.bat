@echo off

netsh advfirewall set allprofiles state on
netsh advfirewall firewall add rule name="!CyberPatriotTCPOut" protocol=TCP dir=out remoteport=21,22,23,161,162,636,3269 action=block
netsh advfirewall firewall add rule name="!CyberPatriotTCPIn" protocol=TCP dir=in remoteport=21,22,23,161,162,636,3269 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPOut" protocol=UDP dir=out remoteport=21,22,23,161,162,636,3269 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDPIn" protocol=UDP dir=in remoteport=21,22,23,161,162,636,3269 action=block

pause
