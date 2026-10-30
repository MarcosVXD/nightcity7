param(
    [Parameter(Mandatory = $true)]
    [string]$ManifestPath
)

if (-not (Test-Path -LiteralPath $ManifestPath)) {
    Write-Error "AndroidManifest.xml não encontrado: $ManifestPath"
    exit 1
}

$content = Get-Content -LiteralPath $ManifestPath -Raw

if ($content -notmatch 'android.permission.INTERNET') {
    $permission = '<uses-permission android:name="android.permission.INTERNET" />'
    $content = [regex]::Replace(
        $content,
        '(<manifest\b[^>]*>)',
        "`$1`r`n    $permission",
        1
    )
}

if ($content -notmatch 'android:usesCleartextTraffic') {
    $content = [regex]::Replace(
        $content,
        '(<application\b[^>]*)(>)',
        '$1 android:usesCleartextTraffic="true"$2',
        1
    )
}

Set-Content -LiteralPath $ManifestPath -Value $content -Encoding UTF8
Write-Host 'Permissão de internet e acesso HTTP local configurados.'
