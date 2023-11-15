BeforeAll {
    $SourceRoot = (Join-Path -Path (Split-Path -Path $PSCommandPath -Parent) -ChildPath '..\..\..\Source') | Convert-Path
    . "$SourceRoot\PSCommonUtils\Public\Show-ComputerBanner.ps1"
}

Describe 'Show-ComputerBanner Tests' {
    BeforeAll {
        $WriteCounts = ((Get-Content -Path "$SourceRoot\PSCommonUtils\Public\Show-ComputerBanner.ps1") -match 'Write-Host').Count
    }
    It 'displays a banner with system information' {
        Mock Write-Host {}
        Show-ComputerBanner
        Assert-MockCalled Write-Host -Times $WriteCounts -Exactly -Scope It
    }
}
