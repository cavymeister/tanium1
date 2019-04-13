#Tanium compatibility
if ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64") {

  $x64PS=join-path $PSHome.tolower().replace("syswow64","sysnative").replace("system32","sysnative") powershell.exe

  $cmd = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($myinvocation.MyCommand.Definition))

  $out = & "$x64PS" -NonInteractive -NoProfile -ExecutionPolicy Bypass -EncodedCommand $cmd

  $out

  exit $lastexitcode

}


<#PS Script to check local administrator policy compliance.
Script checks if the local admin password has been updated or not, and whether there are any users or groups in the local administrators group that shouldn't be.
#>


#who your default local admin user is
$localadmin="danny"
#Max number of days old your local admin password can be to be in compliance
$maxdays=0
#permitted users and groups in the local administrators group
$standardadmins='DHLAB\Domain Admins',"$Env:Computername\Administrator","$Env:Computername\danny"


$localadminmembers=Get-Localgroupmember administrators | select -expandproperty Name 
$diffmem=compare-object $localadminmembers $standardadmins
$today=get-date -Format g
$resetdate=$resetdate=get-localuser $localadmin | select -expandproperty passwordlastset
$dayssincereset=New-TimeSpan -start $resetdate -End $today |select -expandproperty days



if ($dayssincereset -gt $maxdays){
    $compliance='Out of Compliance - Password too old'
    }
        elseif ($diffmem) {
        $compliance='Out of Compliance - Invalid Admin'
            }
            else {
            $compliance='Compliant'
            }
            

Write-Output $compliance