Function Get-CurrentScriptDirectory {
    <#
    .SYNOPSIS
        Returns the directory of the currently executing script.
    .DESCRIPTION
        This simple function returns the proper location of the currently executing script.
    .OUTPUTS
        System.String
    .EXAMPLE
        Get-CurrentScriptDirectory

        # Returns the directory of the currently executing script.
    #>
    [CmdletBinding()]
    [OutputType([String])]
    Param()

    If ($null -ne $HostInvocation) {
        $Out = Split-Path $HostInvocation.MyCommand.Path -Parent
    } else {
        $Out = Split-Path $Script:MyInvocation.MyCommand.Path -Parent
    }

    Return $Out

}
