Function Get-CalendarDefaultDisplayRotated {

    Param (
        $Position,
        $dayHeader,
        $dayOfWeek,
        $completeMonth,
        $HighlightDate,
        $Date,
        $DisplayColour
    )

    For ($j = 0; $j -lt $dayOfWeek.Count; $j++) {
        $host.UI.RawUI.CursorPosition = $Position
        Write-Host $($dayHeader[$j]) -ForegroundColor $DisplayColour.DayOfWeek -NoNewline

        For ($i = 0; $i -lt 6; $i++) {
            [string]$value = ($completeMonth.$($dayOfWeek[$j])[$i])

            $fgColour = Get-CalendarHighlight -Value $value -HighlightDay $HighlightDay -HighlightDate $HighlightDate -DisplayColour $DisplayColour
            Write-Host "$($value.PadLeft(2, ' '))  " -ForegroundColor $fgColour -NoNewline
        }

        $Position.Y++
        Write-Host ''
    }
}
