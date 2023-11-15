BeforeAll {
    $SourceRoot = (Join-Path -Path (Split-Path -Path $PSCommandPath -Parent) -ChildPath '..\..\..\Source') | Convert-Path
    . "$SourceRoot\PSCommonUtils\Public\Get-BatteryStatus.ps1"
}

Describe 'Get-BatteryStatus Tests' {
    Context 'When called with no parameters' {
        It 'returns battery information' {
            $batteryStatus = Get-BatteryStatus
            $batteryStatus | Should -Not -BeNullOrEmpty
        }
    }
}
