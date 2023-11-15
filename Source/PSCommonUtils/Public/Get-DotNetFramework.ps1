Function Get-DotNetFramework {
    <#
    .SYNOPSIS
        This function will retrieve the list of Framework Installed on the computer.
    .DESCRIPTION
        This function will retrieve the list of Framework Installed on the computer.
    .EXAMPLE
        Get-DotNetFramework

        Version
        -------
        2.0.50727.4927
        3.0.30729.4926
        3.0.4506.4926
        3.0.6920.4902
        3.5.30729.4926
        4.8.09032
        4.8.09032
        4.0.0.0
    .LINK
        https://github.com/lazywinadmin/PowerShell
    #>
    [CmdletBinding()]
    Param()

    Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
        Get-ItemProperty -Name Version -EA 0 |
        Where-Object -FilterScript { $_.PSChildName -match '^(?!S)\p{L}' } |
        Select-Object -Property Version

}
