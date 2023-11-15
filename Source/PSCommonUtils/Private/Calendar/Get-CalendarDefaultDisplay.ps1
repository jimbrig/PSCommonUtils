Function Get-CalendarDefaultDisplay {
    Param (
        $Position,
        $dayHeader,
        $dayOfWeek,
        $completeMonth,
        $HighlightDate,
        $Date,
        $DisplayColour
    )

    $host.UI.RawUI.CursorPosition = $Position
    Write-Host $($dayHeader -join '') -ForegroundColor $DisplayColour.DayOfWeek
    $Position.Y++

    For ($i = 0; $i -lt 6; $i++) {
        $host.UI.RawUI.CursorPosition = $Position
        For ($j = 0; $j -lt $dayOfWeek.Count; $j++ ) {
            [string]$value = ($completeMonth.$($dayOfWeek[$j])[$i])

            $fgColour = Get-CalendarHighlight -Value $value -HighlightDay $HighlightDay -HighlightDate $HighlightDate -DisplayColour $DisplayColour
            Write-Host "$($value.PadLeft(2, ' '))  " -ForegroundColor $fgColour -NoNewline
        }

        $Position.Y++
        Write-Host ''
    }
}
