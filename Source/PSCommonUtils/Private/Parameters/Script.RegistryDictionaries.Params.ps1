Function Get-PSRegistryDictionaries {
    [CmdletBinding()]
    Param()
    if ($Script:Dictionary) {
        return
    }
    $Script:Dictionary = @{
        # Those don't really exists, but we want to allow targetting all users or default users
        'HKUAD:'   = 'HKEY_ALL_USERS_DEFAULT' # All users in HKEY_USERS including .DEFAULT_USER (auto mapped from NTUSER.DAT)
        'HKUA:'    = 'HKEY_ALL_USERS' # All users in HKEY_USERS excluding .DEFAULT / .DEFAULT_USER (auto mapped from NTUSER.DAT)
        'HKUD:'    = 'HKEY_DEFAULT_USER' # DEFAULT_USER user in HKEY_USERS (auto mapped from NTUSER.DAT)
        'HKUDUD:'  = 'HKEY_ALL_DOMAIN_USERS_DEFAULT' # All users in HKEY_USERS that are non SPECIAL accounts including .DEFAULT_USER (auto mapped from NTUSER.DAT)

        # All users in HKEY_USERS that are non SPECIAL accounts excluding .DEFAULT / .DEFAULT_USER (auto mapped from NTUSER.DAT)
        'HKUDU:'   = 'HKEY_ALL_DOMAIN_USERS'
        # All users in HKEY_USERS that are non SPECIAL accounts excluding .DEFAULT / .DEFAULT_USER (auto mapped from NTUSER.DAT)
        # But also including non-loaded users (not logged in) (auto mapped from NTUSER.DAT)
        'HKUDUO:'  = 'HKEY_ALL_DOMAIN_USERS_OTHER'
        # All users in HKEY_USERS that are non SPECIAL accounts including .DEFAULT_USER (auto mapped from NTUSER.DAT)
        # But also including non-loaded users (not logged in) (auto mapped from NTUSER.DAT)
        'HKUDUDO:' = 'HKEY_ALL_DOMAIN_USERS_OTHER_DEFAULT'
        # order matters
        'HKCR:'    = 'HKEY_CLASSES_ROOT'
        'HKCU:'    = 'HKEY_CURRENT_USER'
        'HKLM:'    = 'HKEY_LOCAL_MACHINE'
        'HKU:'     = 'HKEY_USERS'
        'HKCC:'    = 'HKEY_CURRENT_CONFIG'
        'HKDD:'    = 'HKEY_DYN_DATA'
        'HKPD:'    = 'HKEY_PERFORMANCE_DATA'
    }

    $Script:HiveDictionary = [ordered] @{
        # Those don't really exists, but we want to allow targetting all users or default users
        # The order matters
        'HKEY_ALL_USERS_DEFAULT'              = 'All+Default'
        'HKUAD'                               = 'All+Default'
        'HKEY_ALL_USERS'                      = 'All'
        'HKUA'                                = 'All'
        'HKEY_ALL_DOMAIN_USERS_DEFAULT'       = 'AllDomain+Default'
        'HKUDUD'                              = 'AllDomain+Default'
        'HKEY_ALL_DOMAIN_USERS'               = 'AllDomain'
        'HKUDU'                               = 'AllDomain'
        'HKEY_DEFAULT_USER'                   = 'Default'
        'HKUD'                                = 'Default'
        'HKEY_ALL_DOMAIN_USERS_OTHER'         = 'AllDomain+Other'
        'HKUDUO'                              = 'AllDomain+Other'
        'HKUDUDO'                             = 'AllDomain+Other+Default'
        'HKEY_ALL_DOMAIN_USERS_OTHER_DEFAULT' = 'AllDomain+Other+Default'
        # Those exists
        'HKEY_CLASSES_ROOT'                   = 'ClassesRoot'
        'HKCR'                                = 'ClassesRoot'
        'ClassesRoot'                         = 'ClassesRoot'
        'HKCU'                                = 'CurrentUser'
        'HKEY_CURRENT_USER'                   = 'CurrentUser'
        'CurrentUser'                         = 'CurrentUser'
        'HKLM'                                = 'LocalMachine'
        'HKEY_LOCAL_MACHINE'                  = 'LocalMachine'
        'LocalMachine'                        = 'LocalMachine'
        'HKU'                                 = 'Users'
        'HKEY_USERS'                          = 'Users'
        'Users'                               = 'Users'
        'HKCC'                                = 'CurrentConfig'
        'HKEY_CURRENT_CONFIG'                 = 'CurrentConfig'
        'CurrentConfig'                       = 'CurrentConfig'
        'HKDD'                                = 'DynData'
        'HKEY_DYN_DATA'                       = 'DynData'
        'DynData'                             = 'DynData'
        'HKPD'                                = 'PerformanceData'
        'HKEY_PERFORMANCE_DATA '              = 'PerformanceData'
        'PerformanceData'                     = 'PerformanceData'

    }

    $Script:ReverseTypesDictionary = [ordered] @{
        'REG_SZ'        = 'string'
        'REG_NONE'      = 'none'
        'REG_EXPAND_SZ' = 'expandstring'
        'REG_BINARY'    = 'binary'
        'REG_DWORD'     = 'dword'
        'REG_MULTI_SZ'  = 'multistring'
        'REG_QWORD'     = 'qword'
        'string'        = 'string'
        'expandstring'  = 'expandstring'
        'binary'        = 'binary'
        'dword'         = 'dword'
        'multistring'   = 'multistring'
        'qword'         = 'qword'
        'none'          = 'none'
    }
}
