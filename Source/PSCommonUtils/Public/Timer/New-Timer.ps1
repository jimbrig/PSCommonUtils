Function New-Timer {
    <#
    .SYNOPSIS
        Creates a new "stopwatch" PowerShell Object.
    .DESCRIPTION
        This function creates a new timer using the "StopWatch" class, allowing measurement of elapsed time in scripts.
    .EXAMPLE
        $Timer = New-Timer
        $Timer.Start()
        Start-Sleep -Seconds 5
        $Timer.Stop()
        $Timer.Elapsed.TotalSeconds

        # Returns 5
    .OUTPUTS
        System.Diagnostics.Stopwatch
    .NOTES
        This Function takes no parameters and is used for the side-effect of creating a new timer/stopwatch object.
    .LINK
        Stop-Timer
    .LINK
        Get-TimerStatus
    #>
    [CmdletBinding()]
    [OutputType([System.Diagnostics.Stopwatch])]
    Param()

    $StopWatch = [System.Diagnostics.Stopwatch]::StartNew()
    Return $StopWatch

}
