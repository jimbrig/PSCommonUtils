
Function Clear-NuGetCache {
    <#
    .SYNOPSIS
        Clears the NuGet cache.

    .DESCRIPTION
        This function clears the NuGet cache by enumerating the known caches and clearing them.

    .OUTPUTS
    This function does not return any output.

    .EXAMPLE
    Clear-NuGetCache
    Clears the NuGet cache.

    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Void], [String[]])]
    Param()

    if (-not(Get-Command -Name 'nuget' -ErrorAction Ignore)) {
        Write-Error -Message 'NuGet is not installed or cannot be found.'
        return
    }

    $KnownCaches = @{
        HttpCache      = 'http-cache'
        GlobalPackages = 'global-packages'
        Temp           = 'temp'
        PluginsCache   = 'plugins-cache'
    }

    [String[]]$GetArgs = 'locals', 'all', '-list'
    [String[]]$ClearArgs = '-clear', '-verbosity', 'quiet'

    Write-Verbose -Message "Enumerating NuGet Caches: NuGet $($GetArgs -join' ')"
    $NuGetLocals = & nuget $GetArgs

    ForEach ($Cache in $KnownCaches.Keys) {
        $CacheVar = "NuGet$Cache"
        $CacheRegex = "^$($KnownCaches[$Cache]): (.*)"
        $CacheFound = $false

        ForEach ($Line in $NuGetLocals) {
            if ($Line -match $CacheRegex) {
                Set-Variable -Name $CacheVar -Value $Matches[1] -WhatIf:$false
                $CacheFound = $true
                break
            }
        }

        if (-not $CacheFound) {
            Write-Warning -Message "NuGet Cache '$Cache' not found."
            continue
        }
    }

}
