Function Get-ComputerInfo {
    <#
        .SYNOPSIS
            This function query some basic Operating System and Hardware Information from a local or remote machine.
        .DESCRIPTION
            This function query some basic Operating System and Hardware Information from a local or remote machine.

            The properties returned are:
              - Computer Name (ComputerName)
              - Operating System Name (OSName)
              - Operating System Version (OSVersion)
              - Memory Installed on the Computer in GigaBytes (MemoryGB)
              - Number of Processor(s) (NumberOfProcessors)
              - Number of Socket(s) (NumberOfSockets)
              - Number of Core(s) (NumberOfCores)

            This function as been tested against Windows Server 2000, 2003, 2008 and 2012.

        .PARAMETER ComputerName
            Specify a ComputerName or IP Address. Default is Localhost.
        .PARAMETER ErrorLog
            Specify the full path of the Error log file. Default is .\Errors.log.
        .PARAMETER Credential
            Specify the alternative credential to use

        .EXAMPLE
            PS> Get-ComputerInfo

            ComputerName       : DESKTOP-PERSONAL
            OSName             : Microsoft Windows 11 Pro Insider Preview
            OSVersion          : 10.0.25987
            MemoryGB           : 32
            NumberOfProcessors : 1
            NumberOfSockets    : 1
            NumberOfCores      : 6

            This example return information about the localhost. By Default, if you don't specify a ComputerName,
            the function will run against the localhost.

        .INPUTS
            System.String
        .OUTPUTS
            System.Management.Automation.PSCustomObject
    #>
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline = $true)]
        [String[]]$ComputerName = 'LocalHost',
        [String]$ErrorLog = '.\Errors.log',
        [Alias('RunAs')]
        [PSCredential]
        [System.Management.Automation.Credential()]$Credential = [System.Management.Automation.PSCredential]::Empty
    )

    Begin { }

    Process {
        ForEach ($Computer in $ComputerName) {
            Write-Verbose -Message "PROCESS - Querying $Computer ..."

            Try {
                $Splatting = @{
                    ComputerName = $Computer
                }

                if ($PSBoundParameters['Credential']) {
                    $Splatting.Credential = $Credential
                }


                $Everything_is_OK = $true
                Write-Verbose -Message "PROCESS - $Computer - Testing Connection"
                Test-Connection -Count 1 -ComputerName $Computer -ErrorAction Stop -ErrorVariable ProcessError | Out-Null

                # Query WMI class Win32_OperatingSystem
                Write-Verbose -Message "PROCESS - $Computer - WMI:Win32_OperatingSystem"
                $OperatingSystem = Get-WmiObject -Class Win32_OperatingSystem @Splatting -ErrorAction Stop -ErrorVariable ProcessError

                # Query WMI class Win32_ComputerSystem
                Write-Verbose -Message "PROCESS - $Computer - WMI:Win32_ComputerSystem"
                $ComputerSystem = Get-WmiObject -Class win32_ComputerSystem @Splatting -ErrorAction Stop -ErrorVariable ProcessError

                # Query WMI class Win32_Processor
                Write-Verbose -Message "PROCESS - $Computer - WMI:Win32_Processor"
                $Processors = Get-WmiObject -Class win32_Processor @Splatting -ErrorAction Stop -ErrorVariable ProcessError

                # Processors - Determine the number of Socket(s) and core(s)
                # The following code is required for some old Operating System where the
                # property NumberOfCores does not exist.
                Write-Verbose -Message "PROCESS - $Computer - Determine the number of Socket(s)/Core(s)"
                $Cores = 0
                $Sockets = 0
                ForEach ($Proc in $Processors) {
                    if ($null -eq $Proc.numberofcores) {
                        if ($null -ne $Proc.SocketDesignation) { $Sockets++ }
                        $Cores++
                    }
                    else {
                        $Sockets++
                        $Cores += $proc.numberofcores
                    }
                }
            }
            Catch {
                $Everything_is_OK = $false
                Write-Warning -Message "Error on $Computer"
                $Computer | Out-File -FilePath $ErrorLog -Append -ErrorAction Continue
                $ProcessError | Out-File -FilePath $ErrorLog -Append -ErrorAction Continue
                Write-Warning -Message "Logged in $ErrorLog"
            }

            if ($Everything_is_OK) {
                Write-Verbose -Message "PROCESS - $Computer - Building the Output Information"
                $Info = [ordered]@{
                    'ComputerName'       = $OperatingSystem.__Server;
                    'OSName'             = $OperatingSystem.Caption;
                    'OSVersion'          = $OperatingSystem.version;
                    'MemoryGB'           = $ComputerSystem.TotalPhysicalMemory / 1GB -as [int];
                    'NumberOfProcessors' = $ComputerSystem.NumberOfProcessors;
                    'NumberOfSockets'    = $Sockets;
                    'NumberOfCores'      = $Cores
                }

                $output = New-Object -TypeName PSObject -Property $Info
                $output
            }
        }
    }

    End {
        # Cleanup
        Write-Verbose -Message 'END - Cleanup Variables'
        Remove-Variable -Name output, info, ProcessError, Sockets, Cores, OperatingSystem, ComputerSystem, Processors,
        ComputerName, ComputerName, Computer, Everything_is_OK -ErrorAction SilentlyContinue

        # End
        Write-Verbose -Message 'END - Script End !'
    }
}
