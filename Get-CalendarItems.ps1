## Usage: .\Get-CalendarItems.ps1 [keyword]

param (
    [Parameter(Mandatory=$true)]
    [string]$SearchString
)

$allmailboxes = (get-EXOmailbox)

foreach ($mailbox in $allmailboxes){

    $mailboxaddress = $mailbox.UserPrincipalName
    $listcalendars = (Get-EXOMailboxFolderStatistics -Identity $mailboxaddress -Folderscope calendar).Name

    # Supposed to search the listcalendars variable for the SearchString, however it's never found 
    If ($listcalendars -contains $SearchString)
    {
        Write-Host "Calendar belongs to account: " $mailboxaddress
   
    }
    Else {
        Write-Host "** Calendar not found in account " $mailboxaddress "**" -f Red
        }
}
