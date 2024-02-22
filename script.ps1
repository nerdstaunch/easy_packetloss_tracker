param (
    [string]$target = "sdsaasdsa.com",
    [int]$count = 900,
    [scriptblock]$OnFailure
)

$successCount = 0
$timeoutCount = 0
$processed = 0

$allTimeouts = @() 
$start = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Output "$timestamp - Pinging $target ..."
Write-Host "$timestamp - Pinging $target ..."

try {
    for ($processed = 0; $processed -lt $count; $processed++) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $pingResult = Test-Connection -ComputerName $target -Count 1 -Quiet

        if ($pingResult) {
            $successCount++
            $pingReply = Test-Connection -ComputerName $target -Count 1
            if ($pingReply -ne $null) {
                Write-Output "[$($processed+1)/$count] $timestamp - Reply from $($pingReply.Address): bytes=$($pingReply.BufferSize) time=$($pingReply.ResponseTime)ms TTL=$($pingReply.TimeToLive)"
                Write-Host "[$($processed+1)/$count] $timestamp - Reply from $($pingReply.Address): bytes=$($pingReply.BufferSize) time=$($pingReply.ResponseTime)ms TTL=$($pingReply.TimeToLive)"
            } else {
                $timeoutCount++
                Write-Output "[$($processed+1)/$count] $timestamp - Request timed out"
                Write-Host "[$($processed+1)/$count] $timestamp - Request timed out" -ForegroundColor Red
                $allTimeouts += "[$($processed+1)/$count] $timestamp"  # Add timestamp to array

                if ($OnFailure) {
                    Invoke-Command -ScriptBlock $OnFailure
                }
            }
        } else {
            $timeoutCount++
            Write-Output "[$($processed+1)/$count] $timestamp - Request timed out."
            Write-Host "[$($processed+1)/$count] $timestamp - Request timed out." -ForegroundColor Red

            $allTimeouts += "[$($processed+1)/$count] $timestamp"  # Add timestamp to array

            if ($OnFailure) {
                Invoke-Command -ScriptBlock $OnFailure
            }
        }

        Start-Sleep -Seconds 1  # Pause for 1 second
    }
} finally {
    $packetLoss = [Math]::Round(($timeoutCount / $processed) * 100, 2)
    $totalTimeouts = $timeoutCount
    Write-Output " "
    Write-Output "===== Summary ====="
    Write-Output "From: $start || To: $timestamp"
    Write-Output "Total Packets sent: $processed"
    Write-Output "Packet loss: $packetLoss%"
    Write-Output "Total timeouts: $totalTimeouts"
    Write-Output " "
    Write-Output "== All Timeouts: =="


    Write-Host " "
    Write-Host "===== Summary ====="
    Write-Host "From: $start || To: $timestamp"
    Write-Host "Total Packets sent: $processed"
    Write-Host "Packet loss: $packetLoss%"
    Write-Host "Total timeouts: $totalTimeouts"
    Write-Host " "
    Write-Host "== All Timeouts: =="
    foreach ($timeout in $allTimeouts) {
        Write-Output $timeout
        Write-Host $timeout
    }
    Write-Output "==================="
    Write-Host "==================="

    # Wait for key press to prevent premature exit
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
}
