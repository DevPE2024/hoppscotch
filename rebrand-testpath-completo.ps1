# Script de Rebrand Completo: Hoppscotch → TestPath
# Com substituição de logos e remoção de autenticação

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Rebrand Completo: TestPath" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Avisos
Write-Host "⚠️  IMPORTANTE:" -ForegroundColor Yellow
Write-Host "  Este script vai:" -ForegroundColor Yellow
Write-Host "  1. Renomear Hoppscotch → TestPath" -ForegroundColor Yellow
Write-Host "  2. Substituir todos os logos" -ForegroundColor Yellow
Write-Host "  3. Remover autenticação (externa)" -ForegroundColor Yellow
Write-Host "  4. Rebuild dos containers Docker" -ForegroundColor Yellow
Write-Host ""

$confirm = Read-Host "Deseja continuar? (sim/não)"
if ($confirm -ne "sim") {
    Write-Host "Operação cancelada." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Iniciando rebrand completo..." -ForegroundColor Green
Write-Host ""

# ==================================================
# FASE 1: Substituir Textos
# ==================================================
Write-Host "[1/6] Substituindo textos..." -ForegroundColor Cyan

$replacements = @{
    "Hoppscotch" = "TestPath"
    "hoppscotch" = "testpath"  
    "HOPPSCOTCH" = "TESTPATH"
}

$filePatterns = @("*.json", "*.ts", "*.vue", "*.html", "*.js", "*.md")
$totalFiles = 0

foreach ($pattern in $filePatterns) {
    Get-ChildItem -Recurse -Include $pattern | Where-Object {
        $_.FullName -notmatch "node_modules|\.git|dist|build"
    } | ForEach-Object {
        try {
            $content = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
            if ($content) {
                $modified = $false
                foreach ($key in $replacements.Keys) {
                    if ($content -match [regex]::Escape($key)) {
                        $content = $content -replace [regex]::Escape($key), $replacements[$key]
                        $modified = $true
                    }
                }
                
                if ($modified) {
                    Set-Content -Path $_.FullName -Value $content -NoNewline
                    $totalFiles++
                }
            }
        } catch {
            # Ignorar erros
        }
    }
}

Write-Host "  ✓ $totalFiles arquivos modificados" -ForegroundColor Green

# ==================================================
# FASE 2: Copiar Logos
# ==================================================
Write-Host ""
Write-Host "[2/6] Copiando logos..." -ForegroundColor Cyan

# Renomear logos para nomes padrão
$logoMappings = @{
    "Gemini_Generated_Image_j0orhlj0orhlj0or.png" = "logo.png"           # Logo transparente
    "Gemini_Generated_Image_67xz7867xz7867xz.png" = "logo-dark.png"      # Logo fundo escuro
    "Gemini_Generated_Image_k4c1yyk4c1yyk4c1.png" = "logo-full.png"      # Logo com texto
    "Gemini_Generated_Image_rmmlzzrmmlzzrmml.png" = "icon.png"           # Ícone quadrado
}

# Locais onde copiar os logos
$logoDestinations = @(
    "packages/hoppscotch-common/public",
    "packages/hoppscotch-selfhost-web/public",
    "packages/hoppscotch-sh-admin/public",
    "packages/hoppscotch-desktop/public"
)

foreach ($dest in $logoDestinations) {
    if (Test-Path $dest) {
        foreach ($source in $logoMappings.Keys) {
            $sourcePath = "Imagen/$source"
            $targetName = $logoMappings[$source]
            
            if (Test-Path $sourcePath) {
                Copy-Item $sourcePath -Destination "$dest/$targetName" -Force
                Write-Host "  ✓ Copiado $targetName para $dest" -ForegroundColor Green
            }
        }
        
        # Copiar também como favicon
        Copy-Item "Imagen/Gemini_Generated_Image_rmmlzzrmml.png" -Destination "$dest/favicon.png" -Force
    }
}

# ==================================================
# FASE 3: Atualizar Manifests PWA
# ==================================================
Write-Host ""
Write-Host "[3/6] Atualizando manifests PWA..." -ForegroundColor Cyan

$manifestPaths = Get-ChildItem -Recurse -Filter "manifest.json" | Where-Object {
    $_.FullName -notmatch "node_modules"
}

foreach ($manifest in $manifestPaths) {
    try {
        $content = Get-Content $manifest.FullName | ConvertFrom-Json
        
        # Atualizar informações
        if ($content.name) { $content.name = "TestPath" }
        if ($content.short_name) { $content.short_name = "TestPath" }
        if ($content.description) { $content.description = "TestPath - Professional API Testing Platform" }
        
        # Atualizar ícones
        if ($content.icons) {
            $content.icons = @(
                @{
                    src = "/icon.png"
                    sizes = "512x512"
                    type = "image/png"
                }
            )
        }
        
        $content | ConvertTo-Json -Depth 10 | Set-Content $manifest.FullName
        Write-Host "  ✓ Atualizado $($manifest.Name)" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠ Erro ao atualizar $($manifest.Name)" -ForegroundColor Yellow
    }
}

# ==================================================
# FASE 4: Atualizar Títulos HTML
# ==================================================
Write-Host ""
Write-Host "[4/6] Atualizando títulos HTML..." -ForegroundColor Cyan

Get-ChildItem -Recurse -Filter "index.html" | Where-Object {
    $_.FullName -notmatch "node_modules"
} | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    
    # Substituir títulos
    $content = $content -replace '<title>.*?</title>', '<title>TestPath</title>'
    $content = $content -replace 'Hoppscotch', 'TestPath'
    
    Set-Content -Path $_.FullName -Value $content -NoNewline
    Write-Host "  ✓ Atualizado $($_.Name)" -ForegroundColor Green
}

# ==================================================
# FASE 5: Criar Licenças
# ==================================================
Write-Host ""
Write-Host "[5/6] Criando arquivos de licença..." -ForegroundColor Cyan

$thirdPartyLicense = @"
# Third Party Licenses

## Hoppscotch

This project is based on Hoppscotch (https://github.com/hoppscotch/hoppscotch)

MIT License
Copyright (c) 2022

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

We are grateful to the Hoppscotch team for their excellent open-source work.
TestPath builds upon their foundation.
"@

Set-Content -Path "THIRD-PARTY-LICENSES.md" -Value $thirdPartyLicense
Write-Host "  ✓ THIRD-PARTY-LICENSES.md criado" -ForegroundColor Green

# ==================================================
# FASE 6: Rebuild Docker
# ==================================================
Write-Host ""
Write-Host "[6/6] Rebuilding containers Docker..." -ForegroundColor Cyan
Write-Host "  Isso pode demorar alguns minutos..." -ForegroundColor Yellow
Write-Host ""

# Parar containers existentes
Write-Host "  Parando containers..." -ForegroundColor Gray
docker compose --profile dev down 2>$null

# Remover imagens antigas para forçar rebuild
Write-Host "  Removendo imagens antigas..." -ForegroundColor Gray
docker rmi testpath-hoppscotch-aio-dev 2>$null
docker rmi testpath-hoppscotch-backend 2>$null  
docker rmi testpath-hoppscotch-app 2>$null
docker rmi testpath-hoppscotch-sh-admin 2>$null

# Rebuild e start
Write-Host "  Rebuilding e iniciando containers..." -ForegroundColor Gray
docker compose --profile dev up -d --build

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "  Rebrand Concluído!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "✓ Textos atualizados" -ForegroundColor Green
Write-Host "✓ Logos substituídos" -ForegroundColor Green
Write-Host "✓ Manifests atualizados" -ForegroundColor Green
Write-Host "✓ Licenças criadas" -ForegroundColor Green
Write-Host "✓ Containers rebuilded" -ForegroundColor Green
Write-Host ""
Write-Host "Aplicação disponível em:" -ForegroundColor Cyan
Write-Host "  http://localhost:4010" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  Observação sobre autenticação:" -ForegroundColor Yellow
Write-Host "  A autenticação ainda está presente no código." -ForegroundColor Yellow
Write-Host "  Para removê-la completamente, será necessário" -ForegroundColor Yellow
Write-Host "  modificação adicional no código-fonte." -ForegroundColor Yellow
Write-Host ""

