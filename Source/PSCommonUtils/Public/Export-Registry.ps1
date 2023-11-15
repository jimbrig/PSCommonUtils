Function Export-Registry {
    <#
    .SYNOPSIS
        Exports a registry key item properties to a .reg file.
    .DESCRIPTION
        This function exports a registry key item properties to a .reg file. The export format can also be altered via
        the -ExportFormat parameter.

        By default, results are written to the native pipeline unless the -ExportPath parameter is used.
    .PARAMETER RegistryKeyPath
        A string representing the registry key path to export. Uses PSDrive fotmatting (e.g. HKLM:\SOFTWARE\Microsoft).
    .PARAMETER ExportPath
        (Optional) A string representing the path to export the registry key to.
        If the path does not exist, it will be created.
    .PARAMETER ExportFormat
        (Optional) A string representing the format to export the registry key to.

        Valid values are:
            - 'reg' (default)
            - 'csv'
            - 'xml'

        Parameter is used in conjunction with the -ExportPath parameter.
    .PARAMETER NoBinaryData
        A switch parameter that will exclude binary data from the export.
    .EXAMPLE
        Export-Registry -RegistryKeyPath 'HKLM:\SOFTWARE\Microsoft' -ExportPath 'C:\Temp\Microsoft.reg'

        # Exports the registry key 'HKLM:\SOFTWARE\Microsoft' to 'C:\Temp\Microsoft.reg' in .reg format.
    #>
    [CmdletBinding(DefaultParameterSetName = 'PrintOnly')]
    Param(
        [Parameter(
            ParameterSetName = 'PrintOnly',
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0,
            HelpMessage = 'Enter a registry path using the PSDrive format (IE: HKCU:\SOFTWARE\TestSoftware'
        )]
        [Parameter(
            ParameterSetName = 'Export',
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]$RegistryKeyPath,

        [Parameter(
            ParameterSetName = 'Export',
            Mandatory = $false
        )]
        [ValidateSet('reg', 'csv', 'xml', IgnoreCase = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ExportFormat = 'reg',

        [Parameter(
            ParameterSetName = 'Export',
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ExportPath,

        [Parameter(
            ParameterSetName = 'Export',
            Mandatory = $false
        )]
        [Switch]$NoBinaryData
    )

    Begin {
        [System.Collections.ArrayList]$ReturnData = @()
    }

    Process {
        ForEach ($Path in $RegistryKeyPath) {
            If ((Test-RegistryKey -RegistryKeyPath $Path) -eq $True) {
                Write-Verbose "Getting properties for registry key: $Path"
                $ParamGetItem = @{
                    Path        = $Path
                    ErrorAction = 'Stop'
                }
                [Microsoft.Win332.RegistryKey]$RegItem = Get-Item @ParamGetItem

                [Array]$RegItemProperties = $RegItem.'Property'

                If ($RegItemProperties.Count -gt 0) {
                    ForEach ($Property in $RegItemProperties) {
                        Write-Verbose "Exporting $Property"
                        [Void]($ReturnData.Add(
                                [PSCustomObject]@{
                                    'Path'         = $RegItem
                                    'Name'         = $Property
                                    'Value'        = $RegItem.GetValue($Property, $null, 'DoNotExpandEnvironmentNames')
                                    'Type'         = $RegItem.GetValueKind($Property)
                                    'ComputerName' = $Env:ComputerName
                                }
                            ))
                    }
                } Else {
                    [Void]($ReturnData.Add(
                            [PSCustomObject]@{
                                'Path'         = $RegItem
                                'Name'         = '(Default)'
                                'Value'        = $null
                                'Type'         = 'String'
                                'ComputerName' = $Env:ComputerName
                            }
                        ))
                }
            } Else {
                Write-Warning "Registry key $Path does not exist."
                Continue
            }
        }
    }

    End {
        If ($null -ne $ReturnData) {
            Switch ($PSCmdlet.ParameterSetName) {
                'Export' {
                    If ($PSBoundParameters.ContainsKey('NoBinaryData')) {
                        Write-Verbose -Message 'Removing Binary data from export.'
                        $ReturnData = $ReturnData | Where-Object { $_.Type -ne 'Binary' }
                    }
                    Switch ($ExportFormat) {
                        'csv' {
                            $ReturnData | Export-Csv -Path $ExportPath -NoTypeInformation -Force
                        }
                        'xml' {
                            $ReturnData | Export-Clixml -Path $ExportPath -Force
                        }
                    }

                    Write-Verbose -Message "Exported registry key to $ExportPath"
                }

                Default {
                    Write-Verbose -Message 'Returning data to pipeline.'
                    $ReturnData
                }
            }
        } Else {
            Write-Warning -Message 'No data returned.'
        }
    }
}
