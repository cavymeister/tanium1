#Tanium compatibility
if ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64") {

  $x64PS=join-path $PSHome.tolower().replace("syswow64","sysnative").replace("system32","sysnative") powershell.exe

  $cmd = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($myinvocation.MyCommand.Definition))

  $out = & "$x64PS" -NonInteractive -NoProfile -ExecutionPolicy Bypass -EncodedCommand $cmd

  $out

  exit $lastexitcode

}
# Write Script Below

#Admin Variables
$localadmin="danny"
$maxdays=0
$standardadmins='DHLAB\Domain Admins','.\Administrator','.\danny'
$localadminmembers=Get-Localgroupmember administrators | select -expandproperty Name 
$localadminmembers=$localadminmembers -replace "$Env:Computername", '.'
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