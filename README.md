# Easy Packet Loss Tracker

## Overview
This PowerShell script helps you monitor packet loss on your network by continuously pinging a specified target (website or IP address) and providing real-time updates on successful responses and timeouts.

## Parameters
The script accepts the following parameters:

- **-target**: Specifies the target website or IP address to ping. Defaults to "google.com" if not specified.
- **-count**: Specifies the number of times to ping the target. Defaults to 900 if not specified.
- **-OnFailure** (scriptblock, optional): A script block to execute when a ping attempt fails (i.e., when a timeout occurs). This script block will be executed in the context of the script. If not provided, no action will be taken on failure.


## Usage
1. Download or clone the script to your local machine.
2. Open a PowerShell terminal.
3. Navigate to the directory where the script is located.
4. Run the script with optional parameters:
   ```powershell
   .\script.ps1 -target "example.com" -count 1000 -OnFailure $failureAction
5. Log to a file with:
    ```powershell
    .\script.ps1 > output.txt

## Output
Please see example_output.txt for a full example run.

At the end of the execution you will get a summary:
   ```
   ===== Summary =====
   From: 2024-02-22 10:11:42 || To: 2024-02-22 10:28:57
   Total Packets sent: 900
   Packet loss: 3.11%
   Total timeouts: 28
   
   == All Timeouts: ==
   [18/900] 2024-02-22 10:12:00
   [29/900] 2024-02-22 10:12:15
   ...
   [866/900] 2024-02-22 10:28:14
   [867/900] 2024-02-22 10:28:19
   ===================