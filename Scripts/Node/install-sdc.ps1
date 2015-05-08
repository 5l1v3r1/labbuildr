﻿<#
.Synopsis
   Short description
.DESCRIPTION
   labbuildr is a Self Installing Windows/Networker/NMM Environemnt Supporting Exchange 2013 and NMM 3.0
.LINK
   https://community.emc.com/blogs/bottk/2014/06/16/announcement-labbuildr-released
#>
#requires -version 3
[CmdletBinding()]
param (
[Parameter(Mandatory=$true)][ValidateSet('1.30-426.0','1.31-258.2','1.31-1277.3','1.31-2333.2','1.32-277.0')][alias('siover')]$ScaleIOVer,
[Parameter(Mandatory=$false)][ValidateScript({$_ -match [IPAddress]$_ })][ipaddress]$mdma = "192.168.2.221",
[Parameter(Mandatory=$false)][ValidateScript({$_ -match [IPAddress]$_ })][ipaddress]$mdmb = "192.168.2.222"
)
$ScriptName = $MyInvocation.MyCommand.Name
$Host.UI.RawUI.WindowTitle = "$ScriptName"
$Builddir = $PSScriptRoot
$Logtime = Get-Date -Format "MM-dd-yyyy_hh-mm-ss"
New-Item -ItemType file  "$Builddir\$ScriptName$Logtime.log"
$mdm_ip = "$mdma,$mdmb"
.$Builddir\test-sharedfolders.ps1
$Setuppath = "\\vmware-host\shared folders\sources\Scaleio\Windows\EMC-ScaleIO-SDC-$ScaleIOVer.msi"
.$Builddir\test-setup.ps1 -setup "SaleioSDC$ScaleIOVer" -setuppath $Setuppath
$ScaleIOArgs = '/i "'+$Setuppath+'" /quiet'
Start-Process -FilePath "msiexec.exe" -ArgumentList $ScaleIOArgs -PassThru -Wait
."C:\Program Files\emc\scaleio\sdc\bin\drv_cfg.exe" --add_mdm --ip $mdm_ip
."C:\Program Files\emc\scaleio\sdc\bin\drv_cfg.exe" --query_mdms
