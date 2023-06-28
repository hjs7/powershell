## Usage: .\az_eac_dupe.ps1 sourceuser@blah.com targetuser@blah.com

param (
    [Parameter(Mandatory=$true)]
    [string]$SourceUserAccount,
    [Parameter(Mandatory=$true)]
    [string]$TargetUserAccount
)

 
#Connect to Azure AD
Connect-AzureAD
 
#Get the Source and Target users
$SourceUser = Get-AzureADUser -Filter "UserPrincipalName eq '$SourceUserAccount'"
$TargetUser = Get-AzureADUser -Filter "UserPrincipalName eq '$TargetUserAccount'"
 
#Check if source and Target users are valid
If($SourceUser -ne $Null -and $TargetUser -ne $Null)
{
    #Get All memberships of the Source user
    $SourceMemberships = Get-AzureADUserMembership -ObjectId $SourceUser.ObjectId | Where-object { $_.ObjectType -eq "Group" } | where-object { $_.SecurityEnabled -ne $True }  
 
    #Get-AzureADUserOwnedObject -ObjectId $SourceUser.ObjectId
 
    #Loop through Each Group
    ForEach($Membership in $SourceMemberships)
    {
        #Check if the user is not part of the group
        $GroupMembers = (Get-AzureADGroupMember -ObjectId $Membership.Objectid).UserPrincipalName
        If ($GroupMembers -notcontains $TargetUserAccount)
        {
            #Add Target user to the Source User's group
            Add-AzureADGroupMember -ObjectId $Membership.ObjectId -RefObjectId $TargetUser.ObjectId
            Write-host "** Added user to Group: " $Membership.DisplayName -f green
        }
        else {
            Write-Host "** User already member of " $Membership.DisplayName -f darkgreen
        }
    }
}

Connect-ExchangeOnline

$userDname = Get-User $SourceuserAccount | select -ExpandProperty DistinguishedName
$usermailsecgroups = Get-Recipient -Filter "Members -eq '$UserDName'" | Where-Object { $_.RecipientType -eq "MailUniversalSecurityGroup" } | Select-Object alias


ForEach($group in $usermailsecgroups) {

        #Check if the target user is already a member of the group
        $MailGroupMembers = Get-DistributionGroupMember -Identity $group.alias | Select-Object WindowsLiveID
        
        If ($MailGroupMembers.windowsliveid -notcontains $TargetUserAccount)
        {
            # Add target user to source user's mail enabled security group
            Add-DistributionGroupMember -Identity $group.alias -Member $TargetUserAccount
            Write-Host "** Added user to mail group: " $group.alias -f green
        }
        else {
            Write-Host "** User already member of " $group.alias -f darkgreen
        }
    }
