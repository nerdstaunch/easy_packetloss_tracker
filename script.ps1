param (
    [string]$target = "google.com"
)

$count = 900  
$successCount = 0
$timeoutCount = 0

$allTimeouts = @() 

$start = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "$timestamp - Pinging $target ..."

for ($i = 0; $i -lt $count; $i++) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $pingResult = Test-Connection -ComputerName $target -Count 1 -Quiet
    
    if ($pingResult) {
        $successCount++
        $pingReply = Test-Connection -ComputerName $target -Count 1
        if ($pingReply -ne $null) {
            Write-Host "[$($i+1)/$count] $timestamp - Reply from $($pingReply.Address): bytes=$($pingReply.BufferSize) time=$($pingReply.ResponseTime)ms TTL=$($pingReply.TimeToLive)"
        } else {
            $timeoutCount++
            Write-Host "[$($i+1)/$count] $timestamp - Request timed out"
            $allTimeouts += "[$($i+1)/$count] $timestamp"
        }
    } else {
        $timeoutCount++
        Write-Host "[$($i+1)/$count] $timestamp - Request timed out."
        $allTimeouts += "[$($i+1)/$count] $timestamp"
    }
    Start-Sleep -Seconds 1 
}

$packetLoss = ($timeoutCount / $count) * 100
Write-Host "~~~~~~~~~~"
Write-Host "From: $start || To: $timestamp"
Write-Host "Total Packets: $count"
Write-Host "Total Timeouts: $timeoutCount"
Write-Host "Packet loss: $packetLoss%"
Write-Host "~~~~~~~~~~"
Write-Host "All Timeouts:"
$allTimeouts
Write-Host "~~~~~~~~~~"