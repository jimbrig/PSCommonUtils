Function Show-Calendar {
    <#
    .SYNOPSIS
        Display a small monthly calendar.

    .DESCRIPTION
        Displays the specified month in calendar view with the current date highlighed.
        An optional date can also be highlighed.
        The view can also be positioned in the console window.

    .PARAMETER Date
        The month and year to display in DateTime format.  If not specified the current month and year is used.

    .PARAMETER Month
        The month to display, 1 - 12.

    .PARAMETER Year
        The year to display.  Defaults to current year.

    .PARAMETER Rotate
        Rotate the calendar display, similar to ncal in Linux

    .PARAMETER HighlightDay
        Specifies one or more days to highlight

    .PARAMETER HighlightDate
        Specifies a particular date to highlight.

    .PARAMETER Position
        Specified the host coordinates to display the calendar.  Does not work with ISE or VSCode.

    .EXAMPLE
        Show-Calendar
        Shows the current month and year.

    .EXAMPLE
        Show-Calendar -Date (Get-Date -Date '01-2000') -HighlightDate '2000-01-20'
        Shows the first month of 2000 and highlights the specific date of the 20th.

    .EXAMPLE
        Show-Calendar -Month 01 -Year 2000 -HighlightDay (11..14)
        Shows the first month of 2000 and highlights the days 11th, 12th, 13th and 14th.

    .EXAMPLE
        Show-Calendar -Position ([System.Management.Automation.Host.Coordinates]::New(20, 10))
        Shows the current month and year at cursor position 20 across, 10 down.

    .NOTES
        For additional information please see my GitHub wiki page
        Based originally on https://github.com/jdhitsolutions/PSCalendar
        Which was based on https://www.leeholmes.com/blog/2008/12/03/showing-calendars-in-your-oof-messages/

    .LINK
        https://github.com/My-Random-Thoughts
#>

    [CmdletBinding(DefaultParameterSetName = 'dateTime')]
    Param(
        [Parameter(ParameterSetName = 'dateTime')]
        [datetime]$Date = (Get-Date -Day 1).Date,

        [Parameter(ParameterSetName = 'monthYear', Mandatory)]
        [ValidateRange(1, 12)]
        [int]$Month,

        [Parameter(ParameterSetName = 'monthYear')]
        [int]$Year = ((Get-Date).Year),

        [switch]$Rotate,

        [ValidateRange(1, 31)]
        [AllowEmptyString()]
        [int[]]$HighlightDay,

        [datetime[]]$HighlightDate,

        [System.Management.Automation.Host.Coordinates]$Position
    )

    Begin {
        $DisplayColour = @{
            Title     = [System.ConsoleColor]::Yellow    # January 2000
            DayOfWeek = [System.ConsoleColor]::White     # Mo Tu We Th Fr Sa Su
            Date      = [System.ConsoleColor]::Gray      # 1 2 3 4 ...
            Today     = [System.ConsoleColor]::Green     # 1
            Highlight = [System.ConsoleColor]::Cyan      # 1
        }

        If ($PSCmdlet.ParameterSetName -eq 'monthYear') {
            $Date = ((Get-Date -Day 1 -Month $Month -Year $Year).Date)
        }

        # Ensure we starting at the 1st of the month
        If ($Date.Day -ne 1) { $Date = $Date.AddDays( - ($Date.Day - 1)) }

        $currCulture = [System.Globalization.CultureInfo]::CurrentCulture
        [datetime]$currentDate = ((Get-Date).Date)
        [datetime]$calDay = $Date
        [string]  $title = $Date.ToString('MMMM yyyy')
        [string[]]$shortDayNames = (($currCulture.DateTimeFormat.ShortestDayNames) * 2)
        [int]     $firstDayOfWeek = $currCulture.DateTimeFormat.FirstDayOfWeek.value__
        [datetime]$endOfMonth = (Get-Date -Year $Date.Year -Month $Date.Month -Day $($currCulture.DateTimeFormat.Calendar.GetDaysInMonth($Date.Year, $Date.Month)))
        [object[]]$dayArray = @(@(), @(), @(), @(), @(), @(), @())
        [string]  $dayCounter = '01234560123456'

        For ($i = 0; $i -lt 7; $i++) {
            # Ensure day names are always two characters long
            [string[]]$dayHeader += $(($shortDayNames[$i + $firstDayOfWeek]).PadLeft(2).Substring(0, 2) + '  ')
        }

        # Pad start of month if required
        While ($calDay.DayOfWeek.value__ -ne $firstDayOfWeek) {
            $calDay = $calDay.AddDays(-1)
        }

        If ($Position) { $originalCursorPosition = $Host.UI.RawUI.CursorPosition }
        Else { $Position = $Host.UI.RawUI.CursorPosition }
    }

    Process {
        While ($calDay.Date -le $endOfMonth.Date) {
            [string]$cDay = $($calDay.Day)
            If (($calDay.Month -lt $Date.Month) -or (($calDay.Year -lt $Date.Year))) { $cDay = ' ' }
            $dayArray[($calDay.DayOfWeek.value__)] += $cDay
            $calDay = $calDay.AddDays(1)
        }

        $completeMonth = [pscustomobject]@{}
        For ($i = 0; $i -le 6; $i++) {
            Add-Member -InputObject $completeMonth `
                -MemberType NoteProperty `
                -Name "Day$($dayCounter.Substring($i + $firstDayOfWeek, 1))" `
                -Value $dayArray[$($dayCounter.Substring($i + $firstDayOfWeek, 1))]
        }

        [string[]]$dayOfWeek = $completeMonth.psObject.Properties.Name

        $host.UI.RawUI.CursorPosition = $Position
        Write-Host $titlePadding$title -ForegroundColor $DisplayColour.Title
        $Position.Y++

        $params = @{
            Position      = $Position
            dayHeader     = $dayHeader
            dayOfWeek     = $dayOfWeek
            completeMonth = $completeMonth
            HighlightDate = $HighlightDate
            Date          = $Date
            DisplayColour = $DisplayColour
        }

        If (-not $Rotate) { Get-CalendarDefaultDisplay @params }
        Else { Get-CalendarDefaultDisplayRotated @params }

        If ($originalCursorPosition) { $host.UI.RawUI.CursorPosition = $originalCursorPosition }
    }

    End {
    }
}
