# Windows System Information Tool
# Collects common hardware, operating system, disk, network, and service details.
# Optional: export the collected information to a CSV file.

param(
    [string]$ExportPath
)

$ErrorActionPreference = "Stop"

try {
    # Collect core Windows and hardware information.
    $os    = Get-CimInstance Win32_OperatingSystem
    $cpu   = Get-CimInstance Win32_Processor | Select-Object -First 1
    $cs    = Get-CimInstance Win32_ComputerSystem
    $drive = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

    # Find the first active network interface that has an IPv4 address.
    $network = Get-NetIPConfiguration |
        Where-Object { $_.IPv4Address -and $_.NetAdapter.Status -eq "Up" } |
        Select-Object -First 1

    # Calculate uptime.
    $uptime = New-TimeSpan -Start $os.LastBootUpTime

    # Convert memory and disk values from bytes to gigabytes.
    $memoryGB = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)

    $diskTotalGB = if ($drive.Size) {
        [math]::Round($drive.Size / 1GB, 2)
    } else {
        0
    }

    $diskFreeGB = if ($drive.FreeSpace) {
        [math]::Round($drive.FreeSpace / 1GB, 2)
    } else {
        0
    }

    $diskUsedGB = [math]::Round($diskTotalGB - $diskFreeGB, 2)

    $diskUsedPercent = if ($diskTotalGB -gt 0) {
        [math]::Round(($diskUsedGB / $diskTotalGB) * 100, 1)
    } else {
        0
    }

    # Read network details safely in case no active adapter is found.
    $ipv4Address = if ($network) {
        ($network.IPv4Address | Select-Object -First 1).IPAddress
    } else {
        "Not available"
    }

    $defaultGateway = if ($network -and $network.IPv4DefaultGateway) {
        ($network.IPv4DefaultGateway | Select-Object -First 1).NextHop
    } else {
        "Not available"
    }

    $dnsServers = if ($network -and $network.DNSServer.ServerAddresses) {
        $network.DNSServer.ServerAddresses -join ", "
    } else {
        "Not available"
    }

    # Count Windows services by status.
    $services = Get-Service
    $runningServices = ($services | Where-Object Status -eq "Running").Count
    $stoppedServices = ($services | Where-Object Status -eq "Stopped").Count

    # Store all collected information in one reusable PowerShell object.
    $systemInfo = [PSCustomObject]@{
        ComputerName       = $env:COMPUTERNAME
        LoggedInUser       = $env:USERNAME
        Manufacturer       = $cs.Manufacturer
        Model              = $cs.Model
        OperatingSystem    = $os.Caption
        WindowsVersion     = $os.Version
        WindowsBuild       = $os.BuildNumber
        Architecture       = $os.OSArchitecture
        UptimeHours        = [math]::Round($uptime.TotalHours, 1)
        CPU                = $cpu.Name
        MemoryGB           = $memoryGB
        DiskTotalGB        = $diskTotalGB
        DiskUsedGB         = $diskUsedGB
        DiskFreeGB         = $diskFreeGB
        DiskUsedPercent    = $diskUsedPercent
        IPv4Address        = $ipv4Address
        DefaultGateway     = $defaultGateway
        DNSServers         = $dnsServers
        RunningServices    = $runningServices
        StoppedServices    = $stoppedServices
        CollectedAt        = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }

    Write-Host ""
    Write-Host "===== Windows System Information ====="
    $systemInfo | Format-List

    # Export the same information when an output path is provided.
    if ($ExportPath) {
        $parentDirectory = Split-Path -Parent $ExportPath

        if ($parentDirectory -and -not (Test-Path $parentDirectory)) {
            New-Item -ItemType Directory -Path $parentDirectory -Force | Out-Null
        }

        $systemInfo | Export-Csv -Path $ExportPath -NoTypeInformation
        Write-Host "Report exported to: $ExportPath"
    }
}
catch {
    Write-Error "Unable to collect system information: $($_.Exception.Message)"
    exit 1
}
