# CPXII-Windows-Scripts
CyberPatriot scripts/checklists created by a CyberPatriot student (me) for my team's personal use on Windows-based VMs. Not authorized for use by other teams.

##Checklist
1. Read the README
2. Do all forensics questions
3. Do any tasks outlined in the README (ex. creating groups)
4. Manage users in accordance with the README using "Computer Management"
	* Remove users that do not belong
	* Change standard users who should be Administrators (and vice versa)
	* Change insecure passwords
	* Enable password expiration
	* Force users to change passwords on next login
5. Manage groups in accordance with the README using "Computer Management"
6. Remove file shares using "Computer Management". However, the default shares (containing "$" in the name) should be kept.
7. Local Security Policy
	* Max password age: 60
	* Min password age: 10
	* Min password length: 8
	* Password complexity: Enabled
	* Reversible encryption: Disabled
	* Password lockout attempts: 5
	* Audits: all on SUCCESS and FAILURE
  
----- To be continued ---->
