# log_analysis.ps1
$logPath = "$PSScriptRoot\access.log"

# 1. Total number of requests
Write-Output "[1] Total number of requests:"
(Get-Content $logPath).Count
Write-Output "`n"

# 2. Unique IP addresses
Write-Output "[2] Unique IP addresses:"
(Get-Content $logPath | ForEach-Object { ($_ -split " ")[0] }) | Sort-Object | Get-Unique
Write-Output "`n"

# 3. Frequency of each IP address (descending)
Write-Output "[3] IP address frequency:"
(Get-Content $logPath | ForEach-Object { ($_ -split " ")[0] }) | Group-Object | Sort-Object Count -Descending | Format-Table Count, Name -AutoSize
Write-Output "`n"

# 4. Requests with 404 status
Write-Output "[4] Requests with 404 status:"
Select-String -Path $logPath -Pattern " 404 "
Write-Output "`n"

# 5. Number of requests per URL
Write-Output "[5] Number of requests per URL:"
(Get-Content $logPath | ForEach-Object { ($_ -split " ")[6] }) | Group-Object | Sort-Object Count -Descending | Format-Table Count, Name -AutoSize
Write-Output "`n"

# 6. Unique User Agents
Write-Output "[6] Unique User Agents:"
(Get-Content $logPath | ForEach-Object {
    if ($_ -match '"[^"]*" "[^"]*" "([^"]+)"') { $matches[1] }
}) | Sort-Object | Get-Unique
Write-Output "`n"

# 7. Requests from a specific IP (e.g., 192.168.1.1)
Write-Output "[7] Requests from IP 192.168.1.1:"
Select-String -Path $logPath -Pattern "^192\.168\.1\.1"
Write-Output "`n"

# 8. Save all 404 requests to a new file
Write-Output "[8] Saving 404 requests to file (404_requests.txt)"
Select-String -Path $logPath -Pattern " 404 " | Set-Content "$env:USERPROFILE\Downloads\404_requests.txt"
