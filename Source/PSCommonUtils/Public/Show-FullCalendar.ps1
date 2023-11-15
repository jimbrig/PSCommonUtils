Function Show-FullCalendar {
    <#
    .SYNOPSIS
        Displays the full 12 monthly calendar as a grid.

    .DESCRIPTION
        Displays the full 12 monthly calendar as a grid.

    .PARAMETER Columns
        Specifies the number of columns to display.  Default is 4

    .PARAMETER Rotate
        Rotate the calendar display, similar to "ncal" in Linux

    .EXAMPLE
        Show-FullCalendar

    .EXAMPLE
        Show-FullCalendar -Columns 2 -Rotate

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts
#>

    Param (
        [int]$Columns = 4,

        [switch]$Rotate
    )

    $position = $Host.UI.RawUI.CursorPosition
    $position.X = 1
    $position.Y++

    1..12 | ForEach-Object {
        Show-Calendar -Month $_ -Position $position -Rotate:$($Rotate.IsPresent)
        $position.X += 32
        If (($_ % $Columns) -eq 0) { $position.X = 1; $position.Y += 9 }
    }

    If ($position.X -gt 10) { $position.Y += 9 }
    $Host.UI.RawUI.CursorPosition = $position
}
