$Key = New-Object Byte[] 32
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
$Key | out-file \\datadrive\wallpaper\WebStat\ssl.key
(get-credential).Password | ConvertFrom-SecureString -key (get-content \\datadrive\wallpaper\WebStat\ssl.key) | set-content \\datadrive\wallpaper\WebStat\config.xml