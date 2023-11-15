Function Show-ComputerBanner {
    <#
    .SYNOPSIS
        Displays a banner with system information.
    .DESCRIPTION
        This function displays a banner with system information that is similar to neofetch on Linux.
    .EXAMPLE
        PS> Show-ComputerBanner

         ,.=:^!^!t3Z3z.,
        :tt:::tt333EE3
        Et:::ztt33EEE  @Ee.,      ..,     2023-11-15 3:32:33 PM
       ;tt:::tt333EE7 ;EEEEEEttttt33#
      :Et:::zt333EEQ. SEEEEEttttt33QL     User: jimmy
      it::::tt333EEF @EEEEEEttttt33F      Hostname: DESKTOP-CUSTOM
     ;3=*^```'*4EEV :EEEEEEttttt33@.      OS: Microsoft Windows 11 Pro Insider Preview
     ,.=::::it=., ` @EEEEEEtttz33QF       Kernel: NT 10.0.25992
    ;::::::::zt33)   '4EEEtttji3P*        Uptime: 1 days, 17 hours, 44 minutes
   :t::::::::tt33.:Z3z..  `` ,..g.        Shell: Powershell 7.4.0-rc.1
   i::::::::zt33F AEEEtttt::::ztF         CPU: Intel Core i7-10750H @ 2.60GHz
  ;:::::::::t33V ;EEEttttt::::t3          Processes: 524
  E::::::::zt33L @EEEtttt::::z3F          Current Load: 8%
 {3=*^```'*4E3) ;EEEtttt:::::tZ`          Memory: 24968mb/32577mb Used
             ` :EEEEtttt::::z7            Disk: 711gb/900gb Used
                 'VEzjt:;;z>*`
                      ``
    .NOTES
        The function uses WMI to query the system information.
    .LINK
        Get-CimInstance
    #>
    [CmdletBinding()]
    [Alias('windowsfetch')]
    Param()

    Begin {

        # Perform WMI Queries
        $Wmi_OperatingSystem = Get-CimInstance -Query 'Select lastbootuptime,TotalVisibleMemorySize,FreePhysicalMemory,caption,version From win32_operatingsystem'
        $Wmi_Processor = Get-CimInstance -Query 'Select Name,LoadPercentage From Win32_Processor'
        $Wmi_LogicalDisk = Get-CimInstance -Query 'Select Size,FreeSpace From Win32_LogicalDisk Where DeviceID="C:"'

        # Assign variables
        $Date = Get-Date
        $OS = $Wmi_Operatingsystem.Caption
        $Kernel = $Wmi_Operatingsystem.Version
        $Uptime = "$(($Uptime = $Date - $Wmi_Operatingsystem.LastBootUpTime).Days) days, $($Uptime.Hours) hours, $($Uptime.Minutes) minutes"
        $Shell = '{0}' -f $PSVersionTable.PSVersion.toString()
        $CPU = $Wmi_Processor.Name -replace '\(C\)', '' -replace '\(R\)', '' -replace '\(TM\)', '' -replace 'CPU', '' -replace '\s+', ' '
        $Processes = (Get-Process).Count
        $CurrentLoad = $Wmi_Processor.LoadPercentage
        $Memory = '{0}mb/{1}mb Used' -f (([math]::round($Wmi_Operatingsystem.TotalVisibleMemorySize / 1KB)) - ([math]::round($Wmi_Operatingsystem.FreePhysicalMemory / 1KB))), ([math]::round($Wmi_Operatingsystem.TotalVisibleMemorySize / 1KB))
        $Disk = '{0}gb/{1}gb Used' -f (([math]::round($Wmi_LogicalDisk.Size / 1GB)) - ([math]::round($Wmi_LogicalDisk.FreeSpace / 1GB))), ([math]::round($Wmi_LogicalDisk.Size / 1GB))

    }

    Process {

        Write-Host ('')
        Write-Host ('')
        Write-Host ('         ,.=:^!^!t3Z3z.,                  ') -ForegroundColor Red
        Write-Host ('        :tt:::tt333EE3                    ') -ForegroundColor Red
        Write-Host ('        Et:::ztt33EEE ') -NoNewline -ForegroundColor Red
        Write-Host (' @Ee.,      ..,     ') -NoNewline -ForegroundColor Green
        Write-Host $Date -ForegroundColor Green
        Write-Host ('       ;tt:::tt333EE7') -NoNewline -ForegroundColor Red
        Write-Host (' ;EEEEEEttttt33#     ') -ForegroundColor Green
        Write-Host ('      :Et:::zt333EEQ.') -NoNewline -ForegroundColor Red
        Write-Host (' SEEEEEttttt33QL     ') -NoNewline -ForegroundColor Green
        Write-Host ('User: ') -NoNewline -ForegroundColor Red
        Write-Host ("$env:username") -ForegroundColor Cyan
        Write-Host ('      it::::tt333EEF') -NoNewline -ForegroundColor Red
        Write-Host (' @EEEEEEttttt33F      ') -NoNewline -ForegroundColor Green
        Write-Host ('Hostname: ') -NoNewline -ForegroundColor Red
        Write-Host ("$env:computername") -ForegroundColor Cyan
        Write-Host ("     ;3=*^``````'*4EEV") -NoNewline -ForegroundColor Red
        Write-Host (' :EEEEEEttttt33@.      ') -NoNewline -ForegroundColor Green
        Write-Host ('OS: ') -NoNewline -ForegroundColor Red
        Write-Host $OS -ForegroundColor Cyan
        Write-Host ('     ,.=::::it=., ') -NoNewline -ForegroundColor Cyan
        Write-Host ("``") -NoNewline -ForegroundColor Red
        Write-Host (' @EEEEEEtttz33QF       ') -NoNewline -ForegroundColor Green
        Write-Host ('Kernel: ') -NoNewline -ForegroundColor Red
        Write-Host ('NT ') -NoNewline -ForegroundColor Cyan
        Write-Host $Kernel -ForegroundColor Cyan
        Write-Host ('    ;::::::::zt33) ') -NoNewline -ForegroundColor Cyan
        Write-Host ("  '4EEEtttji3P*        ") -NoNewline -ForegroundColor Green
        Write-Host ('Uptime: ') -NoNewline -ForegroundColor Red
        Write-Host $Uptime -ForegroundColor Cyan
        Write-Host ('   :t::::::::tt33.') -NoNewline -ForegroundColor Cyan
        Write-Host (':Z3z.. ') -NoNewline -ForegroundColor Yellow
        Write-Host (" ````") -NoNewline -ForegroundColor Green
        Write-Host (' ,..g.        ') -NoNewline -ForegroundColor Yellow
        Write-Host ('Shell: ') -NoNewline -ForegroundColor Red
        Write-Host ("Powershell $Shell") -ForegroundColor Cyan
        Write-Host ('   i::::::::zt33F') -NoNewline -ForegroundColor Cyan
        Write-Host (' AEEEtttt::::ztF         ') -NoNewline -ForegroundColor Yellow
        Write-Host ('CPU: ') -NoNewline -ForegroundColor Red
        Write-Host $CPU -ForegroundColor Cyan
        Write-Host ('  ;:::::::::t33V') -NoNewline -ForegroundColor Cyan
        Write-Host (' ;EEEttttt::::t3          ') -NoNewline -ForegroundColor Yellow
        Write-Host ('Processes: ') -NoNewline -ForegroundColor Red
        Write-Host $Processes -ForegroundColor Cyan
        Write-Host ('  E::::::::zt33L') -NoNewline -ForegroundColor Cyan
        Write-Host (' @EEEtttt::::z3F          ') -NoNewline -ForegroundColor Yellow
        Write-Host ('Current Load: ') -NoNewline -ForegroundColor Red
        Write-Host $CurrentLoad -NoNewline -ForegroundColor Cyan
        Write-Host ('%') -ForegroundColor Cyan
        Write-Host (" {3=*^``````'*4E3)") -NoNewline -ForegroundColor Cyan
        Write-Host (" ;EEEtttt:::::tZ``          ") -NoNewline -ForegroundColor Yellow
        Write-Host ('Memory: ') -NoNewline -ForegroundColor Red
        Write-Host $Memory -ForegroundColor Cyan
        Write-Host ("             ``") -NoNewline -ForegroundColor Cyan
        Write-Host (' :EEEEtttt::::z7            ') -NoNewline -ForegroundColor Yellow
        Write-Host ('Disk: ') -NoNewline -ForegroundColor Red
        Write-Host $Disk -ForegroundColor Cyan
        Write-Host ("                 'VEzjt:;;z>*``           ") -ForegroundColor Yellow
        Write-Host ("                      ````                  ") -ForegroundColor Yellow
        Write-Host ('')


    }

    End {

    }


}
