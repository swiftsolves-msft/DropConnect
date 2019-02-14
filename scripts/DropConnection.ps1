<#
    .DESCRIPTION
        An runbook or Script that acts to terminate connections on the VM, 
        this will accept inputs from Azure's NSG Rule or AzureFW Rule 
        that is recently created to trigger to the VM OS FW rules to drop the active connections. 
        Once dropped after a few seconds OS FW rules will be removed

    .NOTES
        AUTHOR: Nathan Swift
        LASTEDIT: Feb 14, 2019
#>

Param
(
  [Parameter (Mandatory= $true)]
  [String] $portrange = "",
  
  [Parameter (Mandatory= $false)]
  [String] $action = "",

  [Parameter (Mandatory= $false)]
  [String] $direction = "",

  [Parameter (Mandatory= $false)]
  [String] $protocol = "",

  [Parameter (Mandatory= $false)]
  [String] $source = ""


)

<# 

FUTURE: Build some logging, report on success or failure

#>

## Params used for manual testing
#$portrange = "9000-9010"
#$portrange = "3389"
#$source = "Manual"
#$action = "Block"
#$direction = "Inbound"
#$protocol = "TCP"

<# 

FUTURE: Create some conditional logic to check and clean input from azure alert ie. handle protocol both

#>

# Create a rulename
$rulename = $source + "ports" + $portrange

#Create drop connection fw rule
$temprule = New-NetFirewallRule -Name $rulename -DisplayName $rulename -Direction $direction -Action $action -LocalPort $portrange -Protocol $protocol

# Give it a little bit
Start-Sleep -Seconds 60

# remove os fw rule, we don't want to manage these in os, only needed to drop the active connection
$temprule | Remove-NetFirewallRule 

<# 

FUTURE: Check and ensure connection dropped and report on Success or Failure back to user - Teams, Slack, Email ?

#>