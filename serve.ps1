# 🌲 Everwood FAQ Cloud — Servidor Local Ligero
# Este script levanta un servidor web local en el puerto 3000 usando PowerShell nativo.

$port = 3000
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")

try {
    $listener.Start()
    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host "  🌲 Everwood FAQ Cloud - Servidor Local Iniciado" -ForegroundColor Green
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host "  Accede al sistema en tu navegador:" -ForegroundColor White
    Write-Host "  --> http://localhost:$port/" -ForegroundColor Cyan
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host "  Para detener el servidor: Presiona Ctrl + C en esta consola." -ForegroundColor Yellow
    Write-Host ""

    # Determinar ruta absoluta de la carpeta public
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
    if ([string]::IsNullOrEmpty($scriptPath)) {
        $scriptPath = Get-Location
    }
    $publicFolder = Join-Path $scriptPath "public"

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $urlPath = $request.Url.LocalPath
        # Si accede a la raíz, redirigir a index.html
        if ($urlPath -eq "/") {
            $urlPath = "/index.html"
        }

        # Construir ruta de archivo física
        $filePath = Join-Path $publicFolder $urlPath.TrimStart('/')

        if (Test-Path $filePath -PathType Leaf) {
            $bytes = [System.IO.File]::ReadAllBytes($filePath)
            
            # Determinar Content-Type según extensión
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            $contentType = "text/plain"
            switch ($ext) {
                ".html" { $contentType = "text/html; charset=utf-8" }
                ".css"  { $contentType = "text/css; charset=utf-8" }
                ".js"   { $contentType = "application/javascript; charset=utf-8" }
                ".png"  { $contentType = "image/png" }
                ".jpg"  { $contentType = "image/jpeg" }
                ".jpeg" { $contentType = "image/jpeg" }
                ".gif"  { $contentType = "image/gif" }
                ".json" { $contentType = "application/json; charset=utf-8" }
                ".csv"  { $contentType = "text/csv; charset=utf-8" }
                ".txt"  { $contentType = "text/plain; charset=utf-8" }
            }
            
            $response.ContentType = $contentType
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            # Si no existe y es una URL limpia, buscar si existe el archivo .html
            $cleanHtmlPath = $filePath + ".html"
            if (Test-Path $cleanHtmlPath -PathType Leaf) {
                $bytes = [System.IO.File]::ReadAllBytes($cleanHtmlPath)
                $response.ContentType = "text/html; charset=utf-8"
                $response.ContentLength64 = $bytes.Length
                $response.OutputStream.Write($bytes, 0, $bytes.Length)
            } else {
                # 404 Not Found
                $response.StatusCode = 404
                $errBytes = [System.Text.Encoding]::UTF8.GetBytes("404 - Archivo no encontrado por el servidor de Everwood.")
                $response.OutputStream.Write($errBytes, 0, $errBytes.Length)
            }
        }
        $response.Close()
    }
} catch {
    Write-Host "Error en el servidor: $_" -ForegroundColor Red
} finally {
    if ($listener.IsListening) {
        $listener.Stop()
    }
    Write-Host "Servidor detenido." -ForegroundColor Yellow
}
