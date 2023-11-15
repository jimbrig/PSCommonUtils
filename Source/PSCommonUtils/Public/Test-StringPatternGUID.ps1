Function Test-StringPatternGUID {
    <#
    .SYNOPSIS
        Checks if provided input string is a valid GUID.
    .DESCRIPTION
        This function is used to check if a provided input string is a valid GUID. The function uses a regex pattern to
        check the input string against the pattern of a GUID.
    .PARAMETER Guid
        A string representing the GUID to be tested.
    .EXAMPLE
        Test-IsGuid -Guid 'value1'

        # Returns $False
    .EXAMPLE
        Test-StringPatternGUID -Guid '7761bf39-9a9f-42c8-869f-7c6e2689811a'

        # Returns $True
    .OUTPUTS
        System.Boolean
    .INPUTS
        System.String
    .NOTES
        The REGEX pattern used to match against is '(?im)^[{(]?[0-9A-F]{8}[-]?(?:[0-9A-F]{4}[-]?){3}[0-9A-F]{12}[)}]?$'.
    #>
    [CmdletBinding()]
    [OutputType([Bool])]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Guid
    )

    Begin {
        [RegGex]$GUIDRegex = '(?im)^[{(]?[0-9A-F]{8}[-]?(?:[0-9A-F]{4}[-]?){3}[0-9A-F]{12}[)}]?$'
    }

    Process {
        $Out = $Guid -match $GUIDRegex
    }

    End {
        Return $Out
    }
}
