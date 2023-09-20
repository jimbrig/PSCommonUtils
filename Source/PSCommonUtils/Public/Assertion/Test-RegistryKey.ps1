Function Test-RegistryKey {
    <#
    .SYNOPSIS
        Tests if a registry key exists, and if so, if it is valid.
    .DESCRIPTION
        This function tests if a registry key exists, and if so, if it is valid. The function will return $True if the
        key exists and is valid, and $False if the key does not exist or is invalid.
    .PARAMETER RegistryKeyPath
        A string representing the registry key path to test. Uses PSDrive fotmatting (e.g. HKLM:\SOFTWARE\Microsoft).
    .EXAMPLE
        Test-RegistryKey -RegistryKeyPath 'HKLM:\SOFTWARE\Microsoft'

        # Returns $True
    .EXAMPLE
        Test-RegistryKey -RegistryKeyPath 'HKLM:\SOFTWARE\Microsoft\InvalidKey'

        # Returns $False
    .OUTPUTS
        System.Boolean
    .INPUTS
        System.String
    .LINK
        https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psdrives?view=powershell-7.1
    #>
    [CmdletBinding()]
    [OutputType([Bool])]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Key', 'Path')]
        [String]$RegistryKeyPath
    )

    If (Test-Path -Path $RegistryKeyPath) {
        Return (Get-Item -Path $RegistryKeyPath -ErrorAction SilentlyContinue).PsProvider.Name -match 'Registry'
    } Else {
        Return $False
    }

}
