Connect-ExchangeOnline

$user = "xg5admin@lxtf.onmicrosoft.com"
$targetuser = "leeG@lxtf.onmicrosoft.com"

$userDname = Get-User $user | select -ExpandProperty DistinguishedName
$usermailsecgroups = Get-Recipient -Filter "Members -eq '$UserDName'" | Where-Object { $_.RecipientType -eq "MailUniversalSecurityGroup" } | Select-Object alias


ForEach($group in $usermailsecgroups) {

        #Check if the target user is already a member of the group
        $MailGroupMembers = Get-DistributionGroupMember -Identity $group.Alias | Select-Object WindowsLiveID
        
        If ($MailGroupMembers -notcontains $targetuser)
        {
            # Add target user to source user's mail enabled security group
            Add-DistributionGroupMember -Identity $group.alias -Member $targetuser
            Write-Host "Added user to mail group: " $SourceUserMailMembership.alias
        }
        else {
            Write-Host "** No mail-enabled security groups added **" -f Yellow
        }
    }
