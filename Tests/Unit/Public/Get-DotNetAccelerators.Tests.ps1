BeforeAll {
    $SourceRoot = (Join-Path -Path (Split-Path -Path $PSCommandPath -Parent) -ChildPath '..\..\..\Source') | Convert-Path
    . "$SourceRoot\PSCommonUtils\Public\Get-DotNetAccelerators.ps1"
}

Describe 'Get-DotNetAccelerators Tests' {
    Context 'When called with no parameters' {
        It 'returns type accelerators' {
            $typeAccelerators = Get-DotNetAccelerators
            $typeAccelerators | Should -Not -BeNullOrEmpty
        }
    }
}
