@echo off

netsh advfirewall set allprofiles state on
netsh advfirewall firewall add rule name="!CyberPatriotTCP" protocol=TCP dir=out remoteport=21,22,23,161,162,636,3269 action=block
netsh advfirewall firewall add rule name="!CyberPatriotUDP" protocol=UDP dir=out remoteport=21,22,23,161,162,636,3269 action=block

pause