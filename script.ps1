param (
    [string]$target = "google.com"
)

$count = 900 
$successCount = 0
$timeoutCount = 0
$processed = 0

$allTimeouts = @() 
$start = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "$timestamp - Pinging $target ..."

try {
    for ($processed = 0; $processed -lt $count; $processed++) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $pingResult = Test-Connection -ComputerName $target -Count 1 -Quiet

        if ($pingResult) {
            $successCount++
            $pingReply = Test-Connection -ComputerName $target -Count 1
            if ($pingReply -ne $null) {
                Write-Host "[$($processed+1)/$count] $timestamp - Reply from $($pingReply.Address): bytes=$($pingReply.BufferSize) time=$($pingReply.ResponseTime)ms TTL=$($pingReply.TimeToLive)"
            } else {
                $timeoutCount++
                Write-Host "[$($processed+1)/$count] $timestamp - Request timed out"
                $allTimeouts += "[$($processed+1)/$count] $timestamp"  # Add timestamp to array
            }
        } else {
            $timeoutCount++
            Write-Host "[$($processed+1)/$count] $timestamp - Request timed out."
            $allTimeouts += "[$($processed+1)/$count] $timestamp"  # Add timestamp to array
        }

        Start-Sleep -Seconds 1  # Pause for 1 second
    }
} finally {
    $packetLoss = ($timeoutCount / $processed) * 100
    $totalTimeouts = $timeoutCount
    Write-Host "===== Summary ====="
    Write-Host "From: $start || To: $timestamp"
    Write-Host "Total Packets sent: $processed"
    Write-Host "Packet loss: $packetLoss%"
    Write-Host "Total timeouts: $totalTimeouts"
    Write-Host "==================="

    # Print array of timestamps for timeouts
    Write-Host "All Timeouts:"
    foreach ($timeout in $allTimeouts) {
        Write-Host $timeout
    }
    Write-Host "==================="


    # Wait for key press to prevent premature exit
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}
