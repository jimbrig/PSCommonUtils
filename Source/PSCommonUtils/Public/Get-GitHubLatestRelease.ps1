Function Get-GitHubLatestRelease {
    <#
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [Alias('ReleaseURL', 'URL')]
        [URI]$URI
    )

    Begin {
        Set-StrictMode -Version Latest
        $ProgressPreference = 'SilentlyContinue'
        $Responds = Test-Connection -ComputerName $URI.Host -Quiet -Count 1
        if (-not $Responds) {
            throw "Unable to connect to '$($URI.Host)'"
        }


    }

    Process {

        if ($Responds) {
            Write-Verbose "Successfully connected to '$($URI.Host)'"

            try {
                $Response = Invoke-WebRequest -Uri $URI -UseBasicParsing -ErrorAction Stop
                if ($Response.StatusCode -ne 200) {
                    throw "Unable to connect to '$($URI.Host)'"
                }
                [Array]$ResponseOutput = $Response.Content | ConvertFrom-Json
                ForEach ($Item in $ResponseOutput) {
                    [PSCustomObject] @{
                        PublishDate = [DateTime]$Item.published_at
                        CreatedDate = [DateTime]$Item.created_at
                        PreRelease  = [Bool]$Item.prerelease
                        Version     = [Version]$Item.Name.Replace('v', '')
                        Tag         = [String]$Item.tag_name
                        Branch      = [String]$Item.target_commitish
                        Errors      = [String[]]@()
                        # DownloadURL = [URI]$Item.browser_download_url
                    }
                }
            }
            catch {
                Write-Warning "Experiences issues with $($URI.Host)"
                Write-Warning "Exception: $($_.Exception.Message)"
                [PSCustomObject] @{
                    PublishDate = $null
                    CreatedDate = $null
                    PreRelease  = $null
                    Version     = $null
                    Tag         = $null
                    Branch      = $null
                    Errors      = $_.Exception.Message
                    DownloadURL = $null
                }
            }

        } else {

            [PSCustomObject] @{
                PublishDate = $null
                CreatedDate = $null
                PreRelease  = $null
                Version     = $null
                Tag         = $null
                Branch      = $null
                Errors      = "No connection (ping) to $($URI.Host)"
                DownloadURL = $null
            }

        }

    }

    End {
        $ProgressPreference = 'Continue'
        Set-StrictMode -Off
    }
}
