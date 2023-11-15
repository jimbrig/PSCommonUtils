BeforeAll {
    $SourceRoot = (Join-Path -Path (Split-Path -Path $PSCommandPath -Parent) -ChildPath '..\..\..\Source') | Convert-Path
    . "$SourceRoot\PSCommonUtils\Public\Get-MyIPAddress.ps1"
}

Describe 'Get-MyIpAddress Tests' {
    Context 'When called with no parameters' {
        It 'returns an IP address' {
            $ipAddress = Get-MyIpAddress
            $ipAddress | Should -Not -BeNullOrEmpty
        }
    }
}
