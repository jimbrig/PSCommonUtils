Function Get-SourceCode {
    <#
    .SYNOPSIS
        Get the source code of a cmdlet.
    .DESCRIPTION
        This function takes the name of a provided function or cmdlet and attempts to return the source code.
        See the NOTES section for more information.
    .NOTES
        This function utilizes the `CommandMetadata` and `ProxyCommand` classes of the `System.Management.Automation`
        namespace to return the source code of a cmdlet.

        This is not guaranteed to work for all cmdlets, as some cmdlets are written in C# (or packed into binary .DLL's
        and do not have an easily accessible "source code" representation.
    .PARAMETER Name
        (Required | String) The name of the cmdlet or function to retrieve the source code for.
    .EXAMPLE
        Get-SourceCode Get-ChildItem

        This will return the source code for the `Get-ChildItem` cmdlet.
    .EXAMPLE
        Get-SourceCode Get-ChildItem | Out-File -FilePath C:\Temp\Get-ChildItem.ps1

        This will return the source code for the `Get-ChildItem` cmdlet and save it to `C:\Temp\Get-ChildItem.ps1`.
    .LINK
        Originally implemented based off details found here:
        https://stackoverflow.com/questions/266250/can-we-see-the-source-code-for-powershell-cmdlets/20484505#20484505
    .INPUTS
        System.String
    .OUTPUTS
        System.String
    .COMPONENT
        PowerShell
    .ROLE
        Developer
    .FUNCTIONALITY
        Get-SourceCode
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String]$Name
    )

    Begin {

        # Get command
        $Cmd = Get-Command $Name -ErrorAction SilentlyContinue

        # Check if the cmdlet exists
        If (-not ($Cmd)) {
            Throw "The cmdlet '$Name' does not exist."
        }

        $CmdType = $Cmd.CommandType

        # Check if the cmdlet is a proxy command
        if ($CmdType -eq 'Proxy') {
            Throw "The cmdlet '$Name' is a proxy command and does not have a source code representation."
        }

        # Check if the cmdlet is an external script
        if ($CmdType -eq 'ExternalScript') {
            Throw "The cmdlet '$Name' is an external script and does not have a source code representation."
        }

        # Check if the cmdlet is a binary cmdlet
        if ($CmdType -eq 'Binary') {
            Throw "The cmdlet '$Name' is a binary cmdlet and does not have a source code representation."
        }

    }


    Process {

        # Create "meta" object
        $meta = New-Object System.Management.Automation.CommandMetadata $cmd

        # Create proxy command
        $src = [System.Management.Automation.ProxyCommand]::Create($meta)

    }

    End {

        # Return source code
        $src | Out-String

    }

}
