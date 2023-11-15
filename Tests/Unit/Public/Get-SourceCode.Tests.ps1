BeforeAll {
    $SourceRoot = (Join-Path -Path (Split-Path -Path $PSCommandPath -Parent) -ChildPath '..\..\..\Source') | Convert-Path
    . "$SourceRoot\PSCommonUtils\Public\Get-SourceCode.ps1"
}

Describe 'Get-SourceCode Tests' {
    It 'returns the source code for a cmdlet' {
        $Source = Get-SourceCode -Name Get-ChildItem
        $Source | Should -Not -BeNullOrEmpty
        $Source.Length | Should -Be 2765
    }
}

Describe 'Get-SourceCode Error Exception Tests' {
    It 'throws an exception when the cmdlet does not exist' {
        { Get-SourceCode -Name 'NonExistentCmdlet' } | Should -Throw -ExpectedMessage "The cmdlet 'NonExistentCmdlet' does not exist."
    }

    It 'throws an exception when the cmdlet is a proxy command' {
        Mock Get-Command { return @{ CommandType = 'Proxy' } }
        { Get-SourceCode -Name 'ProxyCmdlet' } | Should -Throw -ExpectedMessage "The cmdlet 'ProxyCmdlet' is a proxy command and does not have a source code representation."
    }

    It 'throws an exception when the cmdlet is an external script' {
        Mock Get-Command { return @{ CommandType = 'ExternalScript' } }
        { Get-SourceCode -Name 'ExternalScriptCmdlet' } | Should -Throw -ExpectedMessage "The cmdlet 'ExternalScriptCmdlet' is an external script and does not have a source code representation."
    }

    It 'throws an exception when the cmdlet is a binary cmdlet' {
        Mock Get-Command { return @{ CommandType = 'Binary' } }
        { Get-SourceCode -Name 'BinaryCmdlet' } | Should -Throw -ExpectedMessage "The cmdlet 'BinaryCmdlet' is a binary cmdlet and does not have a source code representation."
    }
}
