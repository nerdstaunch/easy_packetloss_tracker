# Easy Packet Loss Tracket

## Overview
This PowerShell script helps you monitor packet loss on your network by continuously pinging a specified target (website or IP address) and providing real-time updates on successful responses and timeouts.

## Parameters
The script accepts the following parameters:

- **target**: Specifies the target website or IP address to ping. Defaults to "google.com" if not specified.
- **count**: Specifies the number of times to ping the target. Defaults to 900 if not specified.

## Usage
1. Download or clone the script to your local machine.
2. Open a PowerShell terminal.
3. Navigate to the directory where the script is located.
4. Run the script with optional parameters:
   ```powershell
   .\script.ps1 -target "example.com" -count 1000
5. Log to a file with:
.\script.ps1 > output.txt