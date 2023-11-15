BeforeAll {
    $SourceRoot = (Join-Path -Path (Split-Path -Path $PSCommandPath -Parent) -ChildPath '..\..\..\Source') | Convert-Path
    . "$SourceRoot\PSCommonUtils\Public\Get-IPAddressInformation.ps1"
}

Describe 'Get-IPAddressInformation Tests' {
    Context 'When called with a valid IP address' {
        It 'returns IP address information' {
            $ip = '8.8.8.8'
            $result = Get-IPAddressInformation -IP $ip
            $result | Should -Not -BeNullOrEmpty
            $result.status | Should -Be 'success'
            $result.query | Should -Be $ip
        }
    }

    Context 'When called with an invalid IP address' {
        It 'returns an error message' {
            $ip = 'invalid'
            $result = Get-IPAddressInformation -IP $ip
            $result | Should -Not -BeNullOrEmpty
            $result.status | Should -Be 'fail'
            $result.query | Should -Be 'invalid'
            $result.message | Should -Be 'invalid query'
        }
    }
}
