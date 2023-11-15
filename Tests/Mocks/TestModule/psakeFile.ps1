Import-Module PowerShellBuild

Properties {

    $PSBPreference.Build.ModuleName = 'TestModule'
    $PSBPreference.Build.Version = '0.1.0'
    $PSBPreference.Build.ModuleRoot = 'Source/TestModule'
    $PSBPreference.Build.PublicRoot = 'Source/TestModule/Public'
    $PSBPreference.Build.PrivateRoot = 'Source/TestModule/Private'

    # Pester can build the module using both scenarios
    if (Test-Path -Path 'Variable:\PSBuildCompile') {
        $PSBPreference.Build.CompileModule = $global:PSBuildCompile
    } else {
        $PSBPreference.Build.CompileModule = $true
    }

    # If compiling, insert headers/footers for entire PSM1 and for each inserted function
    $PSBPreference.Build.CompileHeader = '# Module Header' + [Environment]::NewLine
    $PSBPreference.Build.CompileFooter = '# Module Footer'
    $PSBPreference.Build.CompileScriptHeader = '# Function header'
    $PSBPreference.Build.CompileScriptFooter = '# Function footer' + [Environment]::NewLine

    # So Pester InModuleScope works
    $PSBPreference.Test.ImportModule = $true
    $PSBPreference.Test.OutputFile = 'fooResults.xml'
    $PSBPreference.Test.CodeCoverage.Enabled = $true
    $PSBPreference.Test.CodeCoverage.Threshold = 0.0

    # Override the default output directory
    $PSBPreference.Build.OutDir = 'Build/Output'
}

Task default -depends Build

Task Build -FromModule PowerShellBuild
