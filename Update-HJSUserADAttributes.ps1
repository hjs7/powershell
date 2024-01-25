<#
.SYNOPSIS
This script updates Active Directory user properties based on a CSV file.

.DESCRIPTION
The script reads a CSV file and updates Active Directory user properties based on the data in the file. 
The CSV file should have columns that match the properties of the AD user and the manager.

.PARAMETER csvFilePath
The path to the CSV file.

.EXAMPLE
.\Update-HJSUserADAttributes.ps1 -csvFilePath "c:\temp\test2.csv"
#>

param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({
            if (Test-Path $_) {
                $true
            }
            else {
                throw "The file $_ does not exist."
            }
        })]
    [string]$CsvFilePath = "c:\temp\test2.csv"
)

Import-Csv -Delimiter "," -Path $CsvFilePath | ForEach-Object {

    $ADUser = Get-ADUser -Filter "name -eq '$($_.PreferredName)'" -Properties Name, UserPrincipalName, Title, Department, Company, Manager, Office
    $Manager = Get-ADUser -Filter "name -eq '$($_.ManagerName)'" -Properties DistinguishedName


    if ($ADUser) {
        if ($_.JobTitle) { $ADUser.Title = $_.JobTitle }
        if ($_.Department) { $ADUser.Department = $_.Department }
        if ($_.CompanyName) { $ADUser.Company = $_.CompanyName }
        if ($_.OfficeLocation) { $ADUser.Office = $_.OfficeLocation }
        if ($Manager) { $ADUser.Manager = $Manager }

        Write-Information "Updating user: $($ADUser.Name)" -InformationAction Continue
        Set-ADUser -Instance $ADUser

    }
    else {
        Write-Warning ("Failed to update " + $($_.name))
    }
}