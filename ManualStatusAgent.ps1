#Set-ExecutionPolicy -ExecutionPolicy bypass -Force
#Start-Transcript -Path "C:\LabFiles\logontasklogs.txt" -Append

#Write-Host "Logon-task-started" 

$commonscriptpath = "C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.10.*\Downloads\0\cloudlabs-common\cloudlabs-windows-functions.ps1"
. $commonscriptpath

#Clone GitHub Repo
#cd C:\LabFiles
#git clone https://github.com/CloudLabsAI-Azure/OpenAIWorkshop-Automation.git

#Installing pip packages
#cd C:\LabFiles\OpenAIWorkshop-Automation\scenarios\incubations\automating_analytics
#pip install -r requirements.txt

$clonefilesautomation = Get-Item -Path 'C:\LabFiles\OpenAIWorkshop-Automation'

#validate all deployments and assignments for manual status agent
if($clonefilesautomation -ne $null)
{
    Write-Information "Validation Passed"
    $validstatus = "Successfull"
}
else {
   Write-Warning "Validation Failed - see log output"
   $validstatus = "Failed"
   }

Function SetDeploymentStatus($ManualStepStatus, $ManualStepMessage)
{
    (Get-Content -Path "C:\WindowsAzure\Logs\status-sample.txt") | ForEach-Object {$_ -Replace "ReplaceStatus", "$ManualStepStatus"} | Set-Content -Path "C:\WindowsAzure\Logs\validationstatus.txt"
   (Get-Content -Path "C:\WindowsAzure\Logs\validationstatus.txt") | ForEach-Object {$_ -Replace "ReplaceMessage", "$ManualStepMessage"} | Set-Content -Path "C:\WindowsAzure\Logs\validationstatus.txt"
}
if ($validstatus -eq "Successfull") {
    $ValidStatus="Succeeded"
    $ValidMessage="Environment is validated and the deployment is successful"

Remove-Item 'C:\WindowsAzure\Logs\CloudLabsCustomScriptExtension.txt' -force
      }
else {
    Write-Warning "Validation Failed - see log output"
    $ValidStatus="Failed"
    $ValidMessage="Environment Validation Failed and the deployment is Failed"
      } 
SetDeploymentStatus $ValidStatus $ValidMessage

#Start the cloudlabs agent service 
CloudlabsManualAgent Start

Unregister-ScheduledTask -TaskName "logontask" -Confirm:$false

Stop-Transcript
