Function Update-MSStoreApps {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boolean])]
    Param()

    if (!$PSCmdlet.ShouldProcess('Microsoft Store', 'Update')) {
        return
    }

    if (!Test-IsAdmin) {
        Write-Error -Message 'This command must be run as an administrator'
        return $false
    }

    $Namespace = 'root\CIMv2\mdm\dmmap'
    $Class = 'MDM_EnterpriseModernAppManagement_AppManagement01'
    $Method = 'UpdateScanMethod'

    $Session = New-CimSession
    $Instance = Get-CimInstance -Namespace $Namespace -ClassName $Class
    $UpdateScan = $Session.InvokeMethod($Namespace, $Instance, $Method, $null)

    $Result = $true
    if ($UpdateScan.ReturnValue.Value -ne 0) {
        Write-Error -Message ('Update of Microsoft Store apps returned: {0}' -f $UpdateScan.ReturnValue.Value)
        $Result = $false
    }

    return $Result
}
