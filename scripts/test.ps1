$ErrorActionPreference = 'Stop'

$rootDir = Split-Path -Parent $PSScriptRoot

Write-Host '[1/4] Validando scripts shell...'
Get-ChildItem -Path (Join-Path $rootDir 'scripts') -Filter '*.sh' | ForEach-Object {
    if (Test-Path $_.FullName) {
        Write-Host "OK: $($_.Name)"
    }
}

Write-Host '[2/4] Validando Dockerfiles...'
$dockerfiles = @(
    (Join-Path $rootDir 'backend/Dockerfile'),
    (Join-Path $rootDir 'frontend/Dockerfile'),
    (Join-Path $rootDir 'database/Dockerfile')
)

foreach ($file in $dockerfiles) {
    if (-not (Test-Path $file)) {
        throw "FALHA: $file"
    }
    Write-Host "OK: $(Split-Path $file -Leaf)"
}

Write-Host '[3/4] Validando manifests Kubernetes...'
$manifests = @(
    (Join-Path $rootDir 'deployment.yml'),
    (Join-Path $rootDir 'services.yml')
)

foreach ($file in $manifests) {
    if (-not (Test-Path $file)) {
        throw "FALHA: $file"
    }
    Write-Host "OK: $(Split-Path $file -Leaf)"
}

Write-Host '[4/4] Teste concluído com sucesso.'
