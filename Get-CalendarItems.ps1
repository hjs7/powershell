<#
    .SYNOPSIS
        Searches for a calendar with a specific name in all Exchange Online mailboxes.

    .DESCRIPTION
        The Get-CalendarItems script searches for a calendar with a specific name in all Exchange Online mailboxes. If a calendar with the specified name is found, the script outputs the email address of the mailbox that contains the calendar.

    .PARAMETER SearchString
        The name of the calendar to search for.

    .EXAMPLE
        Get-CalendarItems -SearchString "Team Meetings"

        This example searches for a calendar named "Team Meetings" in all Exchange Online mailboxes.

    .NOTES
        Author: 
#>

param (
    [Parameter(Mandatory = $true)]
    [string] $SearchString,

    [Parameter()]
    [bool] $ShowWarnings = $true
)

$allMailBoxes = Get-EXOMailbox -ResultSize Unlimited -ErrorAction Stop

foreach ($mailBox in $allMailBoxes) {
    $mailBoxAddress = $mailBox.UserPrincipalName
    $listCalendars = (Get-EXOMailboxFolderStatistics -Identity $mailBoxAddress -Folderscope calendar -ErrorAction Stop).Name

    if ($listCalendars -like $SearchString) {
        Write-Information "Calendar '$SearchString' belongs to account: $mailBoxAddress" -InformationAction Continue
    }
    elseif ($ShowWarnings) {
        Write-Warning "Calendar '$SearchString' not found in account $mailBoxAddress"
    }
}