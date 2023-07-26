## Usage: .\calendar_find.ps1 [keyword]

param (
    [Parameter(Mandatory=$true)]
    [string]$searchstring
)

$allmailboxes = (get-EXOmailbox)

foreach ($mailbox in $allmailboxes){

    $mailboxaddress = $mailbox.UserPrincipalName
    $listcalendars = (Get-EXOMailboxFolderStatistics -Identity $mailboxaddress -Folderscope calendar).Name
    
    If ($listcalendars -contains $searchstring)
    {
        Write-Host "Calendar belongs to account: " $mailboxaddress
   
    }
    Else {
        Write-Host "** Calendar not found in account " $mailboxaddress "**" -f Red
        }
}