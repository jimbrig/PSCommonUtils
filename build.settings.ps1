# -------------------------
# Build Settings
# -------------------------

$projectRoot = if ($Env:BHProjectPath) { $Env:BHProjectPath } else { $PSScriptRoot }
$moduleName = if ($Env:BHProjectName) { $Env:BHProjectName } else { Split-Path -Path $projectRoot -Leaf }
$moduleVersion = (Import-PowerShellDataFile -Path $Env:BHPSModuleManifest).ModuleVersion
$outDir = [IO.Path]::Combine($projectRoot, 'Build')
$moduleOutDir = "$outDir/$moduleName/$moduleVersion"
@{
    ProjectRoot     = $projectRoot
    ProjectName     = $env:BHProjectName
    SUT             = $env:BHModulePath
    Tests           = Get-ChildItem -Path ([IO.Path]::Combine($projectRoot, 'Tests')) -Filter '*.Tests.ps1'
    OutputDir       = $outDir
    ModuleOutDir    = $moduleOutDir
    ManifestPath    = $env:BHPSModuleManifest
    Manifest        = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
    PSVersion       = $PSVersionTable.PSVersion.ToString()
    PSGalleryApiKey = $Env:NUGET_API_TOKEN
}
