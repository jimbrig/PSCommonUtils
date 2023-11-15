BeforeAll {
    $SourceRoot = (Join-Path -Path (Split-Path -Path $PSCommandPath -Parent) -ChildPath '..\..\..\Source') | Convert-Path
    . "$SourceRoot\PSCommonUtils\Public\Get-DotNetFramework.ps1"
}

Describe 'Get-DotNetFramework Tests' {
    Context 'When called with no parameters' {
        It 'returns .NET Framework information' {
            $versions = Get-DotNetFramework
            $versions | Should -Not -BeNullOrEmpty
        }
    }
}
