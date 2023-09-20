Function Stop-Timer {
    <#
    .SYNOPSIS
        Stops/Halts a "stopwatch" PowerShell Object.
    .DESCRIPTION
        This function requires a currently active [System.Diagnostics.Stopwatch] object as input and will invoke the
        class's "Stop()" method, halting the timer.

        If no exceptions are thrown the function will simply return $True
    .PARAMETER Timer
        The [System.Diagnostics.Stopwatch] object to stop. Can be created via the "New-Timer" function.
    .EXAMPLE
        $Timer = New-Timer
        Start-Sleep -Seconds 5
        Stop-Timer -Timer $Timer
        $Timer.Elapsed.TotalSeconds

        # Returns 5
    .OUTPUTS
        System.Boolean
    .INPUTS
        System.Diagnostics.Stopwatch
    .NOTES
        This Function takes a [System.Diagnostics.Stopwatch] object as input and is used for the side-effect
        of stopping a timer/stopwatch object.
    .LINK
        New-Timer
    .LINK
        Get-TimerStatus
    #>
    [CmdletBinding()]
    [OutputType([Boolean])]
    Param(
        [Parameter(Mandatory = $true)]
        [System.Diagnostics.Stopwatch]
        $Timer
    )

    Begin {
        [String]$CurrentConfig = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'
    }

    Process {
        Try {
            $Timer.Stop()
            return $true
        } Catch {
            [String]$ReportedException = $Error[0].Exception.Message
            Write-Warnining -Message "Exception reported while attempting to stop timer; Use '-Verbose' flag for details."
            If ([String]::IsNullOrEmpty($ReportedException) -eq $False) {
                Write-Verbose -Message $ReportedException
            } Else {
                Write-Verbose 'Unknown Exception Reported while attempting to stop timer.'
            }
            Return $False
        }
    }

    End {
        $ErrorActionPreference = $CurrentConfig
    }
}
