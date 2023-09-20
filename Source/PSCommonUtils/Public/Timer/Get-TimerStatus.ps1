Function Get-TimerStatus {
    <#
	.SYNOPSIS
	    Will return boolean value representing status of an existing stopwatch.
	.DESCRIPTION
	    Function requires a [System.Diagnostics.Stopwatch] object as input and will return $True if stopwatch is running or $False otherwise.
	.PARAMETER Timer
	    A [System.Diagnostics.Stopwatch] object representing the StopWatch to check status for.
	.EXAMPLE
	    Get-TimerStatus -Timer $Timer

        # Returns $True if $Timer is running or $False otherwise.
    .OUTPUTS
        System.Boolean
    .INPUTS
        System.Diagnostics.Stopwatch
    .NOTES
        This Function takes a [System.Diagnostics.Stopwatch] object as input and is used for the side-effect
        of checking the status of a timer/stopwatch object.
    .LINK
        New-Timer
    .LINK
        Stop-Timer
    .LINK
        Get-TimerElapsedTime
	#>
    [CmdletBinding()]
    [OutputType([Bool])]
    Param(
        [Parameter(Mandatory = $true)]
        [System.Diagnostics.Stopwatch]
        $Timer
    )

    Return $Timer.IsRunning
}
