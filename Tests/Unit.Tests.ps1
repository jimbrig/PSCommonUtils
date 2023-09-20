Describe "Check results log file present" {
    It "Checks results log file is present" {
        Test-Path -Path "$env:GITHUB_WORKSPACE\Tests\Results\TestResults.xml" | Should -Be $true
    }
}
