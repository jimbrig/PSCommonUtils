BeforeAll {
    $SourceRoot = (Join-Path -Path (Split-Path -Path $PSCommandPath -Parent) -ChildPath '..\..\..\Source') | Convert-Path
    . "$SourceRoot\PSCommonUtils\Public\Show-Calendar.ps1"
}

Describe 'Show-Calendar Tests' {
    Context 'When no parameters are specified' {
        It 'displays the current month and year' {
            Mock Show-Calendar
            Show-Calendar
            Assert-MockCalled Show-Calendar -Times 1 -Exactly -Scope It
        }
    }
}
