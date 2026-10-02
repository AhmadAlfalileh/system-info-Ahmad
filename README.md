# Windows System Information Tool

A beginner-friendly PowerShell project that collects useful Windows system information from one script. The project is designed to practice Windows administration, PowerShell scripting, troubleshooting, and technical documentation.

## Overview

The script gathers common information an IT support technician may need when checking a Windows computer, including hardware, operating system, storage, networking, uptime, and Windows service status.

The information is displayed in the PowerShell console and can optionally be exported to a CSV file for documentation or later review.

## Features

- Computer name and logged-in user
- Manufacturer and model
- Windows edition, version, build number, and architecture
- System uptime
- CPU information
- Installed physical memory
- C: drive total, used, and free storage
- Disk usage percentage
- Active IPv4 address
- Default gateway
- DNS servers
- Running and stopped Windows service counts
- Timestamp showing when the report was collected
- Optional CSV export
- Basic error handling

## Technologies Used

- **PowerShell** - scripting language and shell used to automate Windows administration tasks
- **CIM / WMI classes** - used to query Windows for operating system, processor, computer, and disk information
- **Get-NetIPConfiguration** - used to retrieve active network configuration
- **Get-Service** - used to inspect Windows service status
- **CSV export** - used to save collected information in a portable format

## How It Works

The script uses PowerShell commands to query Windows instead of relying on manually entered information.

Examples:

```powershell
Get-CimInstance Win32_OperatingSystem
```

Retrieves operating system details such as the Windows version, architecture, build number, and last boot time.

```powershell
Get-NetIPConfiguration
```

Retrieves network information such as IPv4 addressing, the default gateway, and DNS configuration.

The script then stores the results inside a `PSCustomObject`. Keeping the data in an object makes it easier to display, export, or reuse later.

## How to Run

### 1. Clone the repository

```powershell
git clone https://github.com/AhmadAlfalileh/system-info-Ahmad.git
```

### 2. Open the project folder

```powershell
cd system-info-Ahmad
```

### 3. Run the script

```powershell
.\Get-SystemInfo.ps1
```

The system information will be displayed in the PowerShell window.

## Export the Report to CSV

To save the collected information:

```powershell
.\Get-SystemInfo.ps1 -ExportPath ".\reports\system-info.csv"
```

If the `reports` folder does not already exist, the script creates it automatically.

## Skills Practiced

This project demonstrates practice with:

- PowerShell scripting
- Windows system administration
- Windows hardware and operating system queries
- Basic networking concepts
- Disk and memory calculations
- Windows service inspection
- Error handling
- Structured data using PowerShell objects
- CSV reporting
- Git and GitHub documentation

## Project Structure

```text
system-info-Ahmad/
├── Get-SystemInfo.ps1
└── README.md
```

## Future Improvements

Possible future additions include:

- Remote computer support
- Event log summaries
- Installed software inventory
- Windows Update status
- Security and firewall status
- HTML report generation
- Additional health checks and warnings

## Purpose

This project was created as part of an IT and cybersecurity portfolio to demonstrate hands-on PowerShell automation and Windows troubleshooting skills.
