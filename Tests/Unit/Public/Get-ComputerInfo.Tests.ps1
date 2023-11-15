BeforeAll {
    $SourceRoot = (Join-Path -Path (Split-Path -Path $PSCommandPath -Parent) -ChildPath '..\..\..\Source') | Convert-Path
    . "$SourceRoot\PSCommonUtils\Public\Get-ComputerInfo.ps1"

    $CurrDir = Get-Location
    Set-Location $PSScriptRoot
}

AfterAll {
    Remove-Item 'Errors.log' -Force
    Set-Location $CurrDir
}

Describe 'Get-ComputerInfo Tests' {

    BeforeAll {
        $result = Get-ComputerInfo
        $resultError = Get-ComputerInfo -ComputerName 'InvalidComputer'
    }

    Context 'When no parameters are specified' {
        It 'returns information about the local machine' {
            $result.ComputerName | Should -Be $env:COMPUTERNAME
            $result.OSName | Should -Not -BeNullOrEmpty
            $result.OSVersion | Should -Not -BeNullOrEmpty
            $result.MemoryGB | Should -BeGreaterThan 0
            $result.NumberOfProcessors | Should -BeGreaterThan 0
            $result.NumberOfSockets | Should -BeGreaterThan 0
            $result.NumberOfCores | Should -BeGreaterThan 0
        }
    }

    Context 'When an invalid computer name is specified' {
        It 'generates Errors.log' {
            $resultError | Should -BeNullOrEmpty
            Test-Path -Path 'Errors.log' | Should -Be $true
        }
    }
}
