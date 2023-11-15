# ---------------------------------------------------------------
# Build Related Pester Tests
# ---------------------------------------------------------------

<#
    .DESCRIPTION
        This file contains Pester tests for the module build task(s).
    .LINK
        https://github.com/psake/PowerShellBuild/blob/pesterv5/tests/build.tests.ps1
    .NOTES
        - Checks Module Compilation
        - Checks Module can be Created/Built
        - Checks Module can be Imported
#>



Describe 'Build' {

    BeforeAll {
        $Global:TestModulePath = "$PSScriptRoot/../Mocks/TestModule/TestModule"
        $Global:TestModuleManifestPath = "$TestModulePath/TestModule.psd1"
        $Global:TestModuleManifest = Import-PowerShellDataFile -Path $TestModuleManifestPath
        $Global:TestModuleOutputPath = "$PSScriptRoot/../Mocks/TestModule/Build/Output/TestModule/$($TestModuleManifest.ModuleVersion)"

        If (Test-Path $TestModuleOutputPath) {
            Remove-Item -Path $TestModuleOutputPath -Recurse -Force | Out-Null
        }

        If (!(Test-Path $TestModuleOutputPath)) {
            New-Item -Path $TestModuleOutputPath -ItemType Directory -Force | Out-Null
        }
    }

    Context 'Compile Module' {
        BeforeAll {

            $OutputPath = $TestModuleOutputPath

            # build is PS job so psake doesn't freak out because it's nested
            Start-Job -Scriptblock {
                Set-Location $using:PSScriptRoot/../Mocks/TestModule
                $global:PSBuildCompile = $true
                ./build.ps1 -Task Build
            } | Wait-Job
        }

        AfterAll {
            Remove-Item -Path "$PSScriptRoot/../Mocks/TestModule/Output" -Recurse -Force
        }

        It 'Creates module' {
            $OutputPath | Should -Exist
        }

        It 'Has PSD1 and monolithic PSM1' {
            (Get-ChildItem -Path $OutputPath -File).Count | Should -Be 2
            "$outputPath/TestModule.psd1" | Should -Exist
            "$outputPath/TestModule.psm1" | Should -Exist
            "$outputPath/Public" | Should -Not -Exist
            "$outputPath/Private" | Should -Not -Exist
        }

        It 'Has module header text' {
            "$outputPath/TestModule.psm1" | Should -FileContentMatch '# Module Header'
        }

        It 'Has module footer text' {
            "$outputPath/TestModule.psm1" | Should -FileContentMatch '# Module Footer'
        }

        It 'Has function header text' {
            "$outputPath/TestModule.psm1" | Should -FileContentMatch '# Function header'
        }

        It 'Has function hfootereader text' {
            "$outputPath/TestModule.psm1" | Should -FileContentMatch '# Function footer'
        }

        It 'Does not contain excluded files' {
            (Get-ChildItem -Path $outputPath -File -Filter '*excludeme*' -Recurse).Count | Should -Be 0
            "$outputPath/TestModule.psm1" | Should -Not -FileContentMatch '=== EXCLUDE ME ==='
        }

        It 'Has MAML help XML' {
            "$outputPath/en-US/TestModule-help.xml" | Should -Exist
        }
    }

    Context 'Dot-sourced module' {
        BeforeAll {

            $OutputPath = $TestModuleOutputPath

            # build is PS job so psake doesn't freak out because it's nested
            Start-Job -Scriptblock {
                Set-Location $using:PSScriptRoot/../Mocks/TestModule
                $global:PSBuildCompile = $false
                ./build.ps1 -Task Build
            } | Wait-Job
        }

        AfterAll {
            Remove-Item -Path "$PSScriptRoot/../Mocks/TestModule/Output" -Recurse -Force
        }

        It 'Creates module' {
            $outputPath | Should -Exist
        }

        It 'Has PSD1 and dot-sourced functions' {
            (Get-ChildItem -Path $outputPath).Count | Should -BeGreaterThan 2
            "$outputPath/TestModule.psd1" | Should -Exist
            "$outputPath/TestModule.psm1" | Should -Exist
            "$outputPath/Public" | Should -Exist
            "$outputPath/Private" | Should -Exist
        }

        It 'Has MAML help XML' {
            "$OutputPath/en-US/TestModule-help.xml" | Should -Exist
        }
    }
}
