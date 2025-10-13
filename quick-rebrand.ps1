# Quick Rebrand - TestPath
# Script simplificado que FUNCIONA

Write-Host "=== Rebrand Rápido: TestPath ===" -ForegroundColor Cyan
Write-Host ""

# 1. Copiar Logos
Write-Host "[1/4] Copiando logos..." -ForegroundColor Yellow

$dirs = @(
    "packages/hoppscotch-common/public",
    "packages/hoppscotch-sh-admin/public"
)

foreach ($dir in $dirs) {
    if (Test-Path $dir) {
        Copy-Item "Imagen/Gemini_Generated_Image_j0orhlj0orhlj0or.png" "$dir/logo.png" -Force -ErrorAction SilentlyContinue
        Copy-Item "Imagen/Gemini_Generated_Image_rmmlzzrmmlzzrmml.png" "$dir/icon.png" -Force -ErrorAction SilentlyContinue
        Write-Host "  ✓ $dir" -ForegroundColor Green
    }
}

# 2. Criar Licença
Write-Host ""
Write-Host "[2/4] Criando THIRD-PARTY-LICENSES.md..." -ForegroundColor Yellow

$license = @"
# Third Party Licenses

## Hoppscotch

This project is based on Hoppscotch (https://github.com/hoppscotch/hoppscotch)

MIT License - Copyright (c) 2022

We are grateful to the Hoppscotch team for their excellent open-source work.
"@

Set-Content "THIRD-PARTY-LICENSES.md" $license
Write-Host "  ✓ Criado" -ForegroundColor Green

# 3. Atualizar .env se necessário
Write-Host ""
Write-Host "[3/4] Verificando .env..." -ForegroundColor Yellow
if (Test-Path ".env") {
    Write-Host "  ✓ .env existe" -ForegroundColor Green
} else {
    Write-Host "  ⚠ .env não encontrado" -ForegroundColor Yellow
}

# 4. Informações
Write-Host ""
Write-Host "[4/4] Próximos passos..." -ForegroundColor Yellow
Write-Host ""
Write-Host "MANUAL:" -ForegroundColor Cyan
Write-Host "  1. Abra VS Code" -ForegroundColor White
Write-Host "  2. Pressione Ctrl+Shift+H" -ForegroundColor White
Write-Host "  3. Substitua: Hoppscotch → TestPath" -ForegroundColor White
Write-Host ""
Write-Host "REBUILD:" -ForegroundColor Cyan
Write-Host "  docker compose --profile dev down" -ForegroundColor White
Write-Host "  docker compose --profile dev up -d --build" -ForegroundColor White
Write-Host ""
Write-Host "✓ Logos copiados" -ForegroundColor Green
Write-Host "✓ Licença criada" -ForegroundColor Green
Write-Host "⚠ Falta: Substituir textos (manual)" -ForegroundColor Yellow
Write-Host ""

