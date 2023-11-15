Import-Module PowerShellBuild

. PowerShellBuild.IB.Tasks

$PSBPreference.Build.CompileModule = $true

Task Build $PSBPreference.build.dependencies

Task . Build
