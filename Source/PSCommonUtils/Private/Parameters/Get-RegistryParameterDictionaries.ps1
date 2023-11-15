Function Get-RegistryParameterDictionaries {
    <#
    #>
    [CmdletBinding()]
    Param()

    if ($Script:Dictionary) {
        return
    }

    $Script:Dictionary = [Ordered] @{
        'Hive' = [Ordered] @{
            'HKCR:' = 'HKEY_CLASSES_ROOT'
            'HKCU:' = 'HKEY_CURRENT_USER'
            'HKLM:' = 'HKEY_LOCAL_MACHINE'
            'HKU:'  = 'HKEY_USERS'
            'HKCC:' = 'HKEY_CURRENT_CONFIG'
            'HKDD:' = 'HKEY_DYN_DATA'
            'HKPD:' = 'HKEY_PERFORMANCE_DATA'
        }
        'Type' = [Ordered] @{
            'REG_NONE'      = 'None'
            'REG_SZ'        = 'String'
            'REG_EXPAND_SZ' = 'ExpandString'
            'REG_BINARY'    = 'Binary'
            'REG_DWORD'     = 'DWord'
            'REG_MULTI_SZ'  = 'MultiString'
            'REG_QWORD'     = 'QWord'
        }
    }
}
