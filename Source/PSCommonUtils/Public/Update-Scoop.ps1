Function Update-Scoop {
    <#
        .SYNOPSIS
            Update Scoop to the latest version.
        .DESCRIPTION
            This function will update Scoop to the latest version.
        .PARAMETER ProgressParentId
            The parent ID of the progress bar.
        .INPUTS
            None
        .OUTPUTS
            Void, PSCustomObject
            The Scoop update result.
        .EXAMPLE
            Update-Scoop -Verbose
            Update Scoop to the latest version.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Void], [PSCustomObject])]
    Param(
        [ValidateRange(-1, [Int]::MaxValue)]
        [Int]$ProgressParentId
    )

    if (!(Get-Command -Name 'scoop' -ErrorAction Ignore)) {
        Write-Error -Message 'Unable to update Scoop as scoop command not found.'
        return
    }

    $WriteProgressParams = @{
        Activity = 'Updating Scoop'
    }

    if ($PSBoundParameters.ContainsKey('ProgressParentId')) {
        $WriteProgressParams['ParentId'] = $ProgressParentId
        $WriteProgressParams['Id'] = $ProgressParentId + 1
    }

    $Result = [PSCustomObject]@{
        Scoop   = $null
        Apps    = $null
        Cleanup = $null
    }

    [String[]]$UpdateScoopArgs = 'update', '--quiet'
    [String[]]$UpdateAppsArgs = 'update', '*', '--quiet'
    [String[]]$CleanupArgs = 'cleanup', '*', '--cache'
    if ($WhatIfPreference) {
        $UpdateAppsArgs = 'status', '--local'
    }

    # There's no simple way to disable the output of the download progress bar
    # during Scoop updates. It adds a lot of noise to the captured output, so
    # we filter out relevant lines using a regular expression match.
    $ProgressBarRegex = '\[=*(> *)?\] +[0-9]{1,3}%'

    if ($WhatIfPreference -or $PSCmdlet.ShouldProcess('Scoop', 'Update')) {
        Write-Progress @WriteProgressParams -Status 'Updating Scoop' -PercentComplete 1
        Write-Verbose -Message ('Updating Scoop: scoop {0}' -f ($UpdateScoopArgs -join ' '))
        $Result.Scoop = & scoop @UpdateScoopArgs 6>&1
    }

    if ($WhatIfPreference -or $PSCmdlet.ShouldProcess('Scoop apps', 'Update')) {
        Write-Progress @WriteProgressParams -Status 'Updating apps' -PercentComplete 20
        Write-Verbose -Message ('Updating apps: scoop {0}' -f ($UpdateAppsArgs -join ' '))
        $Result.Apps = & scoop @UpdateAppsArgs 6>&1 | Where-Object { $_ -notmatch $ProgressBarRegex }
    }

    if ($PSCmdlet.ShouldProcess('Scoop obsolete files', 'Remove')) {
        Write-Progress @WriteProgressParams -Status 'Cleaning-up obsolete files' -PercentComplete 80
        Write-Verbose -Message ('Cleaning-up obsolete files: scoop {0}' -f ($CleanupArgs -join ' '))
        $Result.Cleanup = & scoop @CleanupArgs 6>&1
    }

    Write-Progress @WriteProgressParams -Completed

    return $Result
}
