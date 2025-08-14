# Simple system info for Windows PowerShell

$os  = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$cs  = Get-CimInstance Win32_ComputerSystem
$drive = Get-PSDrive -Name C

Write-Output "===== System Info (PowerShell) ====="
Write-Output "Computer Name: $($env:COMPUTERNAME)"
Write-Output ("OS: {0} {1} {2}" -f $os.Caption, $os.Version, $os.OSArchitecture)
$uptime = New-TimeSpan -Start $os.LastBootUpTime
Write-Output ("Uptime: {0:N1} hours" -f $uptime.TotalHours)
Write-Output ("CPU: {0}" -f $cpu.Name)
Write-Output ("Memory: {0} GB" -f ([math]::Round($cs.TotalPhysicalMemory/1GB,2)))
if ($drive) {
  $total = ($drive.Used + $drive.Free)/1GB
  Write-Output ("Disk (C:): Used {0} GB / {1} GB" -f ([math]::Round($drive.Used/1GB,2)), [math]::Round($total,2))
}
