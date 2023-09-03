# -------------------------------------------------------
# PSCommonUtils PowerShell Module
# -------------------------------------------------------

# Dot Source Functions (and Classes/Enums/etc.)
$Public = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Public/*.ps1')  -Recurse -ErrorAction Stop)
$Private = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Private/*.ps1') -Recurse -ErrorAction Stop)
$Classes = @()
$Enums = @()
$DSCResources = @()

If (!(Test-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Classes'))) {
    $Classes = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Classes/*.ps1') -Recurse -ErrorAction Stop)
}

If (!(Test-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Enums/'))) {
    $Enums = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Enums/*.ps1') -Recurse -ErrorAction Stop)
}

If (!(Test-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath 'DSCResources'))) {
    $DSCResources = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'DSCResources/*.ps1') -Recurse -ErrorAction Stop)
}

$All = @($Public + $Private + $Classes + $Enums + $DSCResources)

ForEach ($File in $All) {
    Try {
        . $File.FullName
    }
    Catch {
        Write-Warning -Message "Failed to import function $($File.FullName): $_"
    }
}

Export-ModuleMember -Function $Public.BaseName
Export-ModuleMember -Alias * -Function *
