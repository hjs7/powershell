## Usage: .\Get-CalendarItems.ps1 [keyword]

param (
    [Parameter(Mandatory=$true)]
    [string]$SearchString
)

$allMailBoxes = (get-EXOmailbox)

foreach ($mailBox in $allMailBoxes){

    $mailBoxAddress = $mailBox.UserPrincipalName
    $listCalendars = (Get-EXOMailboxFolderStatistics -Identity $mailBoxAddress -Folderscope calendar).Name

    # Supposed to search the listcalendars variable for the SearchString, however it's never found 
    if ($listCalendars -contains $SearchString)
    {
        Write-Host "Calendar belongs to account: " $mailBoxAddress
    }
    else {
        Write-Host "** Calendar not found in account " $mailBoxAddress "**" -f Red
        }
}
