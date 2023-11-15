Function Get-DotNetAccelerators {
    <#
    .SYNOPSIS
        Gets the .NET type accelerators.
    .DESCRIPTION
        Gets the .NET type accelerators.
    .EXAMPLE
        Get-DotNetAccelerators

        Gets the .NET type accelerators.
    .NOTES
        Author: Jimmy Briggs <jimmy.briggs@jimbrig.com>
    .INPUTS
        None
    .OUTPUTS
        System.Management.Automation.PSObject
    #>
    [CmdletBinding()]
    [OutputType('System.Management.Automation.PSObject')]
    Param()

    [PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::get
}
