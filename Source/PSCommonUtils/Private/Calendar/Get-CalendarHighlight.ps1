Function Get-CalendarHighlight {
    Param (
        $Value,
        $HighlightDay,
        $HighlightDate,
        $DisplayColour
    )

    $fgColour = $DisplayColour.Date
    If (-not $Value.Trim()) { Return $fgColour }

    # Is HIGHLIGHT
    If (($HighlightDate) -contains (Get-Date -Day $value -Month $Date.Month -Year $Date.Year).Date) {
        $fgColour = $DisplayColour.Highlight
    }

    If ($HighlightDay -contains $value) {
        $fgColour = $DisplayColour.Highlight
    }

    # Is TODAY
    If (($currentDate.Day -eq $value      ) -and
        ($currentDate.Month -eq $Date.Month) -and
        ($currentDate.Year -eq $Date.Year )) { $fgColour = $DisplayColour.Today }

    Return $fgColour
}
