param(
    [int]$Port = 3000,
    [string]$Path = $PSScriptRoot
)

$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Prefixes.Add("http://127.0.0.1:$Port/")

try {
    $listener.Start()
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host "  ✨ Once Upon a Page - Fairytale Bookstore Server ✨" -ForegroundColor Yellow
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host "  Local URL:   http://localhost:$Port/" -ForegroundColor Cyan
    Write-Host "  Shop URL:    http://localhost:$Port/shop.html" -ForegroundColor Cyan
    Write-Host "  Realms URL:  http://localhost:$Port/categories.html" -ForegroundColor Cyan
    Write-Host "  Directory:   $Path" -ForegroundColor Gray
    Write-Host "  Server is listening on port $Port..." -ForegroundColor Green
    Write-Host "==========================================================" -ForegroundColor Green

    $mimeTypes = @{
        '.html' = 'text/html; charset=utf-8'
        '.htm'  = 'text/html; charset=utf-8'
        '.css'  = 'text/css; charset=utf-8'
        '.js'   = 'application/javascript; charset=utf-8'
        '.json' = 'application/json; charset=utf-8'
        '.png'  = 'image/png'
        '.jpg'  = 'image/jpeg'
        '.jpeg' = 'image/jpeg'
        '.gif'  = 'image/gif'
        '.svg'  = 'image/svg+xml'
        '.ico'  = 'image/x-icon'
        '.woff' = 'font/woff'
        '.woff2'= 'font/woff2'
        '.ttf'  = 'font/ttf'
        '.webp' = 'image/webp'
    }

    while ($listener.IsListening) {
        try {
            $context = $listener.GetContext()
            $request = $context.Request
            $response = $context.Response

            # Enable CORS headers
            $response.AddHeader("Access-Control-Allow-Origin", "*")
            $response.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
            $response.AddHeader("Access-Control-Allow-Headers", "Content-Type")

            $urlPath = [System.Uri]::UnescapeDataString($request.Url.AbsolutePath)
            if ($urlPath -eq '/' -or $urlPath -eq '') {
                $urlPath = '/index.html'
            }

            # Route aliases
            if ($urlPath -eq '/shop') { $urlPath = '/shop.html' }
            if ($urlPath -eq '/categories') { $urlPath = '/categories.html' }
            if ($urlPath -eq '/home') { $urlPath = '/index.html' }

            $relPath = $urlPath.TrimStart('/').Replace('/', [System.IO.Path]::DirectorySeparatorChar)
            $localFilePath = Join-Path $Path $relPath

            if ([System.IO.File]::Exists($localFilePath)) {
                $ext = [System.IO.Path]::GetExtension($localFilePath).ToLower()
                $mime = if ($mimeTypes.ContainsKey($ext)) { $mimeTypes[$ext] } else { 'application/octet-stream' }
                $response.ContentType = $mime
                $response.StatusCode = 200
                $bytes = [System.IO.File]::ReadAllBytes($localFilePath)
                $response.ContentLength64 = $bytes.Length
                $response.OutputStream.Write($bytes, 0, $bytes.Length)
                Write-Host "[$([DateTime]::Now.ToString('HH:mm:ss'))] 200 GET $urlPath" -ForegroundColor DarkGreen
            }
            else {
                $response.StatusCode = 404
                $response.ContentType = 'text/html; charset=utf-8'
                $notFoundHtml = @"
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>404 Not Found - Once Upon a Page</title>
  <style>
    body { font-family: 'Playfair Display', Georgia, serif; text-align: center; padding: 60px 20px; background: #fff7fb; color: #241729; }
    h1 { color: #7e5713; font-size: 2.5rem; margin-bottom: 0.5rem; }
    p { font-size: 1.1rem; color: #625b72; margin-bottom: 1.5rem; }
    a { display: inline-block; padding: 10px 24px; background: #d4a359; color: #583a00; text-decoration: none; border-radius: 12px; font-weight: bold; }
    a:hover { background: #7e5713; color: #fff; }
  </style>
</head>
<body>
  <h1>✧ 404 - Realm Not Found ✧</h1>
  <p>The parchment or tome you were searching for has vanished into thin air.</p>
  <p><a href="/">Return to Grand Library</a></p>
</body>
</html>
"@
                $bytes = [System.Text.Encoding]::UTF8.GetBytes($notFoundHtml)
                $response.ContentLength64 = $bytes.Length
                $response.OutputStream.Write($bytes, 0, $bytes.Length)
                Write-Host "[$([DateTime]::Now.ToString('HH:mm:ss'))] 404 GET $urlPath" -ForegroundColor Red
            }
            $response.OutputStream.Close()
        }
        catch [System.Net.HttpListenerException] {
            break
        }
        catch {
            Write-Host "Request error: $_" -ForegroundColor DarkYellow
        }
    }
}
catch {
    Write-Host "Server startup error: $_" -ForegroundColor Red
}
finally {
    if ($listener -and $listener.IsListening) {
        $listener.Stop()
    }
    if ($listener) {
        $listener.Close()
    }
}
