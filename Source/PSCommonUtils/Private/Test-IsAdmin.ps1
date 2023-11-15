Function Test-IsAdmin {
    <#
    #>
    [CmdletBinding()]
    [OutputType([Boolean])]
    Param()

    $Identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $Principal = New-Object Security.Principal.WindowsPrincipal($Identity)

    return $Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
