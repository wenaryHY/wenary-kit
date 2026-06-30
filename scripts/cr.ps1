param(
    [switch]$Review,
    [switch]$Auth,
    [switch]$Doctor,
    [switch]$Stats,
    [switch]$Plain,
    [switch]$Agent,
    [switch]$Light,
    [string]$Base = '',
    [string]$Dir = '',
    [string]$Type = '',
    [Parameter(ValueFromRemainingArguments)]$Remaining
)

Add-Type -AssemblyName System.Security
$data = Get-Content "C:\Users\Wenary\AppData\Local\Programs\CodeRabbit\.crkey" -Raw | ConvertFrom-Json
$encryptedBytes = [Convert]::FromBase64String($data.Data)
$entropy = [Convert]::FromBase64String($data.Entropy)
$decryptedBytes = [System.Security.Cryptography.ProtectedData]::Unprotect($encryptedBytes, $entropy, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
$key = [System.Text.Encoding]::UTF8.GetString($decryptedBytes)

$args = @()
if ($Review) { $args += 'review' }
if ($Auth) { $args += 'auth' }
if ($Doctor) { $args += 'doctor' }
if ($Stats) { $args += 'stats' }
if ($Plain) { $args += '--plain' }
if ($Agent) { $args += '--agent' }
if ($Light) { $args += '--light' }
if ($Base) { $args += '--base', $Base }
if ($Dir) { $args += '--dir', $Dir }
if ($Type) { $args += '--type', $Type }
$args += '--api-key', $key
$args += $Remaining

& "C:\Users\Wenary\AppData\Local\Programs\CodeRabbit\bin\coderabbit.exe" @args
exit $LASTEXITCODE