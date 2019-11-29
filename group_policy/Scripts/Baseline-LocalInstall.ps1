<#
.SYNOPSIS
Applies a Windows security configuration baseline to local group policy.

.DESCRIPTION
Applies a Windows security configuration baseline to local group policy.

Execute this script with one of these required command-line switches to install
the corresponding baseline:
 -Win10DomainJoined    - Windows 10, domain-joined
 -Win10NonDomainJoined - Windows 10, non-domain-joined
 -WSMember             - Windows Server, domain-joined member server
 -WSNonDomainJoined    - Windows Server, non-domain-joined
 -WSDomainController   - Windows Server, domain controller

REQUIREMENTS:

* PowerShell execution policy must be configured to allow script execution; for example,
  with a command such as the following:
  Set-ExecutionPolicy RemoteSigned

* LGPO.exe must be in the Tools subdirectory or somewhere in the Path. LGPO.exe is part of
  the Security Compliance Toolkit and can be downloaded from this URL:
  https://www.microsoft.com/download/details.aspx?id=55319

.PARAMETER Win10DomainJoined
Installs security configuration baseline for Windows 10, domain-joined

.PARAMETER Win10NonDomainJoined
Installs security configuration baseline for Windows 10, non-domain-joined

.PARAMETER WSMember
Installs security configuration baseline for Windows Server, domain-joined member server

.PARAMETER WSNonDomainJoined
Installs security configuration baseline for Windows Server, non-domain-joined

.PARAMETER WSDomainController
Installs security configuration baseline for Windows Server, domain controller

#>

param(
    [Parameter(Mandatory = $true, ParameterSetName = 'Win10DJ')]
    [switch]
    $Win10DomainJoined,

    [Parameter(Mandatory = $true, ParameterSetName = 'Win10NonDJ')]
    [switch]
    $Win10NonDomainJoined,

    [Parameter(Mandatory = $true, ParameterSetName = 'WSDJ')]
    [switch]
    $WSMember,

    [Parameter(Mandatory = $true, ParameterSetName = 'WSNonDJ')]
    [switch]
    $WSNonDomainJoined,

    [Parameter(Mandatory = $true, ParameterSetName = 'WSDC')]
    [switch]
    $WSDomainController
)

<#
### Do not allow this script to run on a domain controller.
### Reference re detection logic: 
### https://docs.microsoft.com/en-au/windows/win32/cimwin32prov/win32-operatingsystem
#>
if ((Get-WmiObject Win32_OperatingSystem).ProductType -eq 2)
{
    $errmsg = "`r`n" +
              "###############################################################################################`r`n" +
              "###  Execution of this local-policy script is not supported on domain controllers. Exiting. ###`r`n" +
              "###############################################################################################`r`n"
    Write-Error $errmsg
    return
}

# ### EDIT THIS SECTION WHEN GPO NAMES ARE UPDATED ###
# GPO names expected in the current baseline set
$GPO_IE11_Computer   = "MSFT Internet Explorer 11 - Computer"
$GPO_IE11_User       = "MSFT Internet Explorer 11 - User"
$GPO_Win10_BitLocker = "MSFT Windows 10 1903 - BitLocker"
$GPO_Win10_Computer  = "MSFT Windows 10 1903 - Computer"
$GPO_Win10_User      = "MSFT Windows 10 1903 - User"
$GPO_All_DefenderAV  = "MSFT Windows 10 1903 and Server 1903 - Defender Antivirus"
$GPO_All_DomainSec   = "MSFT Windows 10 1903 and Server 1903 - Domain Security"
$GPO_CredentialGuard = "MSFT Windows 10 1903 and Server 1903 Member Server - Credential Guard"
$GPO_WS_DC           = "MSFT Windows Server 1903 - Domain Controller"
$GPO_WS_DC_VBS       = "MSFT Windows Server 1903 - Domain Controller Virtualization Based Security"
$GPO_WS_Member       = "MSFT Windows Server 1903 - Member Server"

function AddToCollection([System.Collections.Hashtable]$ht, [System.String]$GpoName)
{
    $guid = $GpoMap[$GpoName]
    if ($null -eq $guid)
    {
        $Script:bMissingGPO = $true
        Write-Error "MISSING GPO: $GpoName"
    }
    else
    {
        $ht.Add($GpoName, $guid)
    }
}

# Identify all the directories/paths
$RootDir = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Path)
$ParentDir = [System.IO.Path]::GetDirectoryName($RootDir)
$GPOsDir = [System.IO.Path]::Combine($ParentDir, "GPOs")
$ToolsDir = [System.IO.Path]::Combine($RootDir, "Tools")
$MapToolPs1 = [System.IO.Path]::Combine($ToolsDir, "MapGuidsToGpoNames.ps1")

# Identify all the GPOs in the baseline package by name and GUID
$GpoMap = & $MapToolPs1 $GPOsDir

$bMissingGPO = $false

# Determine which GPOs to import
$GPOsToInstall = @{}
$baselineLabel = ""

# ### EDIT THIS SECTION IF WHICH GPOs TO BE APPLIED TO WHICH OSes ARE ALTERED ###
# GPOs for Windows 10
if ($Win10DomainJoined -or $Win10NonDomainJoined)
{
    if ($Win10DomainJoined)
    {
        $baselineLabel = "Windows 10 - domain-joined"
    }
    else
    {
        $baselineLabel = "Windows 10 - non-domain-joined"
    }
    AddToCollection $GPOsToInstall $GPO_IE11_Computer
    AddToCollection $GPOsToInstall $GPO_IE11_User
    AddToCollection $GPOsToInstall $GPO_Win10_Computer
    AddToCollection $GPOsToInstall $GPO_Win10_User
    AddToCollection $GPOsToInstall $GPO_Win10_BitLocker
    AddToCollection $GPOsToInstall $GPO_All_DomainSec
    AddToCollection $GPOsToInstall $GPO_All_DefenderAV
    AddToCollection $GPOsToInstall $GPO_CredentialGuard
}

# GPOs for Windows Server (not Domain Controller)
if ($WSMember -or $WSNonDomainJoined)
{
    if ($WSMember)
    {
        $baselineLabel = "Windows Server - domain-joined"
    }
    else
    {
        $baselineLabel = "Windows Server - non-domain-joined"
    }
    AddToCollection $GPOsToInstall $GPO_IE11_Computer
    AddToCollection $GPOsToInstall $GPO_IE11_User
    AddToCollection $GPOsToInstall $GPO_All_DomainSec
    AddToCollection $GPOsToInstall $GPO_All_DefenderAV
    AddToCollection $GPOsToInstall $GPO_CredentialGuard
    AddToCollection $GPOsToInstall $GPO_WS_Member
}

# GPOs for Windows Server Domain Controller
if ($WSDomainController)
{
    $baselineLabel = "Windows Server - domain controller"
    AddToCollection $GPOsToInstall $GPO_IE11_Computer
    AddToCollection $GPOsToInstall $GPO_IE11_User
    AddToCollection $GPOsToInstall $GPO_All_DomainSec
    AddToCollection $GPOsToInstall $GPO_All_DefenderAV
    AddToCollection $GPOsToInstall $GPO_WS_DC
    AddToCollection $GPOsToInstall $GPO_WS_DC_VBS
}

# If any named GPOs not found, stop
if ($bMissingGPO)
{
    return
}

# Verify availability of LGPO.exe; if not in path, but in Tools subdirectory, add Tools subdirectory to the path.
$origPath = ""
if ($null -eq (Get-Command LGPO.exe -ErrorAction SilentlyContinue))
{
    if (Test-Path -Path $ToolsDir\LGPO.exe)
    {
        $origPath = $env:Path
        $env:Path = "$ToolsDir;" + $origPath
        Write-Verbose $env:Path
        Write-Verbose (Get-Command LGPO.exe)
    }
    else
    {
$lgpoErr = @"

  ============================================================================================
    LGPO.exe must be in the Tools subdirectory or somewhere in the Path. LGPO.exe is part of
    the Security Compliance Toolkit and can be downloaded from this URL:
    https://www.microsoft.com/download/details.aspx?id=55319
  ============================================================================================
"@
        Write-Error $lgpoErr
        return
    }
}

################################################################################
# Preparatory...

# All log output in Unicode
$OutputEncodingPrevious = $OutputEncoding
$OutputEncoding = [System.Text.ASCIIEncoding]::Unicode

Push-Location $RootDir

# Log file full path
$logfile = [System.IO.Path]::Combine($RootDir, "BaselineInstall-" + [datetime]::Now.ToString("yyyyMMdd-HHmm-ss") + ".log")
Write-Host "Logging to $logfile ..." -ForegroundColor Cyan
$MyInvocation.MyCommand.Name + ", " + [datetime]::Now.ToString() | Out-File -LiteralPath $logfile


# Functions to simplify logging and reporting progress to the display
$dline = "=================================================================================================="
$sline = "--------------------------------------------------------------------------------------------------"
function Log([string] $line)
{
    $line | Out-File -LiteralPath $logfile -Append
}
function LogA([string[]] $lines)
{
    $lines | foreach { Log $_ }
}
function ShowProgress([string] $line)
{
    Write-Host $line -ForegroundColor Cyan
}
function ShowProgressA([string[]] $lines)
{
    $lines | foreach { ShowProgress $_ }
}
function LogAndShowProgress([string] $line)
{
    Log $line
    ShowProgress $line
}
function LogAndShowProgressA([string[]] $lines)
{
    $lines | foreach { LogAndShowProgress $_ }
}


LogAndShowProgress $sline
LogAndShowProgress $baselineLabel
LogAndShowProgress "GPOs to be installed:"
$GPOsToInstall.Keys | Sort-Object | foreach { 
    LogAndShowProgress "`t$_" 
}
LogAndShowProgress $dline
Log ""

################################################################################

# Wrapper to run LGPO.exe so that both stdout and stderr are redirected and
# PowerShell doesn't bitch about content going to stderr.
function RunLGPO([string] $lgpoParams)
{
    ShowProgress "Running LGPO.exe $lgpoParams"
    LogA (cmd.exe /c "LGPO.exe $lgpoParams 2>&1")
}

################################################################################

# Non-GPOs and preparatory...

LogAndShowProgress "Copy custom administrative templates..."
Copy-Item -Force ..\Templates\*.admx $env:windir\PolicyDefinitions
Copy-Item -Force ..\Templates\*.adml $env:windir\PolicyDefinitions\en-US
Log $dline

LogAndShowProgress "Configuring Client Side Extensions..."
RunLGPO "/v /e mitigation /e audit /e zone /e DGVBS"
Log $dline

LogAndShowProgress "Installing Exploit Protection settings..."
# TODO: Some way to capture this output?
Set-ProcessMitigation -PolicyFilePath $RootDir\ConfigFiles\EP.xml
Log $dline

if ($Win10DomainJoined -or $Win10NonDomainJoined)
{
    LogAndShowProgress "Disable Xbox scheduled task on Win10..."
    LogA (SCHTASKS.EXE /Change /TN \Microsoft\XblGameSave\XblGameSaveTask /DISABLE)
    Log $dline
}

# Install the GPOs
$GPOsToInstall.Keys | Sort-Object | foreach {
    $gpoName = $_
    $gpoGuid = $GPOsToInstall[$gpoName]

    Log $sline
    LogAndShowProgress "Applying GPO `"$gpoName`"..." # ( $gpoGuid )..."
    Log $sline
    Log ""
    RunLGPO "/v /g  ..\GPOs\$gpoGuid"
    Log $dline
    Log ""
}

# For non-domain-joined, back out the local-account restrictions
if ($Win10NonDomainJoined -or $WSNonDomainJoined)
{
    LogAndShowProgress "Non-domain-joined: back out the local-account restrictions..."
    RunLGPO "/v /s ConfigFiles\DeltaForNonDomainJoined.inf /t ConfigFiles\DeltaForNonDomainJoined.txt"
}

# Restore original path if modified
if ($origPath.Length -gt 0)
{
    $env:Path = $origPath
}
# Restore original output encoding
$OutputEncoding = $OutputEncodingPrevious

# Restore original directory location
Pop-Location

################################################################################
$exitMessage = @"
To test properly, create a new non-administrative user account and reboot.

Detailed logs are in this file:
$logfile

Please post feedback to the Security Baselines Tech Community:
https://aka.ms/secguidechat
"@

Write-Host $dline
Write-Host $dline
Write-Host $exitMessage
Write-Host $dline
Write-Host $dline

################################################################################
