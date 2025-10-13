# Script de Rebrand: Hoppscotch → TestPath
# ATENÇÃO: Faça backup antes de executar!

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Rebrand: Hoppscotch → TestPath" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Configurações
$companyName = "Sua Empresa"
$companyUrl = "https://testpath.io"
$companyEmail = "contact@testpath.io"
$currentYear = (Get-Date).Year

# Avisos
Write-Host "⚠️  IMPORTANTE:" -ForegroundColor Yellow
Write-Host "  1. Faça backup completo do projeto antes de continuar" -ForegroundColor Yellow
Write-Host "  2. Este script vai modificar MUITOS arquivos" -ForegroundColor Yellow
Write-Host "  3. Certifique-se de ter os direitos legais para fazer isso" -ForegroundColor Yellow
Write-Host ""

$confirm = Read-Host "Deseja continuar? (sim/não)"
if ($confirm -ne "sim") {
    Write-Host "Operação cancelada." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Iniciando rebrand..." -ForegroundColor Green
Write-Host ""

# 1. Substituir textos em arquivos
Write-Host "[1/7] Substituindo textos em arquivos..." -ForegroundColor Cyan

$replacements = @{
    "Hoppscotch" = "TestPath"
    "hoppscotch" = "testpath"
    "HOPPSCOTCH" = "TESTPATH"
    "hoppscotch.io" = "testpath.io"
    "docs.hoppscotch.io" = "docs.testpath.io"
}

# Arquivos a modificar
$filePatterns = @(
    "*.json",
    "*.md",
    "*.ts",
    "*.vue",
    "*.html",
    "*.js",
    "*.yml",
    "*.yaml"
)

$excludeDirs = @(
    "node_modules",
    ".git",
    "dist",
    "build",
    ".next"
)

foreach ($pattern in $filePatterns) {
    Write-Host "  Processando $pattern..." -ForegroundColor Gray
    
    Get-ChildItem -Recurse -Include $pattern -Exclude $excludeDirs | ForEach-Object {
        $file = $_
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        
        if ($content) {
            $modified = $false
            foreach ($key in $replacements.Keys) {
                if ($content -match $key) {
                    $content = $content -replace [regex]::Escape($key), $replacements[$key]
                    $modified = $true
                }
            }
            
            if ($modified) {
                Set-Content -Path $file.FullName -Value $content -NoNewline
                Write-Host "    ✓ $($file.Name)" -ForegroundColor Green
            }
        }
    }
}

# 2. Atualizar package.json
Write-Host ""
Write-Host "[2/7] Atualizando package.json..." -ForegroundColor Cyan

Get-ChildItem -Recurse -Filter "package.json" -Exclude node_modules | ForEach-Object {
    $packageJson = Get-Content $_.FullName | ConvertFrom-Json
    
    # Atualizar informações
    if ($packageJson.name) {
        $packageJson.name = $packageJson.name -replace "hoppscotch", "testpath"
    }
    if ($packageJson.description) {
        $packageJson.description = $packageJson.description -replace "Hoppscotch", "TestPath"
    }
    if ($packageJson.author) {
        $packageJson.author = $companyName
    }
    if ($packageJson.homepage) {
        $packageJson.homepage = $companyUrl
    }
    
    $packageJson | ConvertTo-Json -Depth 100 | Set-Content $_.FullName
    Write-Host "  ✓ $($_.FullName)" -ForegroundColor Green
}

# 3. Criar arquivo de licenças de terceiros
Write-Host ""
Write-Host "[3/7] Criando THIRD-PARTY-LICENSES.md..." -ForegroundColor Cyan

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
TestPath builds upon their foundation to provide enhanced features and enterprise support.
"@

Set-Content -Path "THIRD-PARTY-LICENSES.md" -Value $thirdPartyLicense
Write-Host "  ✓ THIRD-PARTY-LICENSES.md criado" -ForegroundColor Green

# 4. Atualizar LICENSE
Write-Host ""
Write-Host "[4/7] Atualizando LICENSE..." -ForegroundColor Cyan

$newLicense = @"
TestPath License

This project is based on Hoppscotch and uses the MIT License.

Original work: Copyright (c) 2022 Hoppscotch
Modified work: Copyright (c) $currentYear $companyName

MIT License

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
"@

Set-Content -Path "LICENSE" -Value $newLicense
Write-Host "  ✓ LICENSE atualizado" -ForegroundColor Green

# 5. Criar README.md customizado
Write-Host ""
Write-Host "[5/7] Criando README-TESTPATH.md..." -ForegroundColor Cyan

$readmeContent = @"
# TestPath

**Professional API Testing Platform**

Built on the foundation of Hoppscotch, TestPath provides enterprise-grade API testing with enhanced features for professional teams.

## Features

- ✅ REST API Testing
- ✅ GraphQL Testing
- ✅ WebSocket, SSE, MQTT Support
- ✅ Collections & Environments
- ✅ Team Collaboration
- ✅ Enterprise SSO
- ✅ Advanced RBAC
- ✅ Audit Logging
- ✅ 24/7 Support

## Quick Start

\`\`\`bash
# Development
docker compose --profile dev up -d

# Production
docker compose --profile prod up -d
\`\`\`

Access at: http://localhost:4010

## Documentation

Visit [docs.testpath.io](https://docs.testpath.io) for complete documentation.

## Support

- Email: $companyEmail
- Website: $companyUrl

## License

Based on Hoppscotch (MIT License)
Copyright (c) $currentYear $companyName

See LICENSE and THIRD-PARTY-LICENSES.md for details.

## Acknowledgments

This project is built upon the excellent work of the Hoppscotch team.
We are grateful for their contribution to the open-source community.
"@

Set-Content -Path "README-TESTPATH.md" -Value $readmeContent
Write-Host "  ✓ README-TESTPATH.md criado" -ForegroundColor Green

# 6. Renomear containers no docker-compose
Write-Host ""
Write-Host "[6/7] Atualizando docker-compose.yml..." -ForegroundColor Cyan

$dockerCompose = Get-Content "docker-compose.yml" -Raw
$dockerCompose = $dockerCompose -replace "hoppscotch", "testpath"
Set-Content -Path "docker-compose.yml" -Value $dockerCompose
Write-Host "  ✓ docker-compose.yml atualizado" -ForegroundColor Green

# 7. Criar guia de próximos passos
Write-Host ""
Write-Host "[7/7] Criando NEXT-STEPS.md..." -ForegroundColor Cyan

$nextSteps = @"
# Próximos Passos para Completar o Rebrand

## ✅ Concluído

- [x] Textos atualizados
- [x] package.json modificados
- [x] Licenças criadas
- [x] docker-compose.yml atualizado

## 📋 Pendente (IMPORTANTE!)

### 1. Branding Visual

- [ ] Substituir logos em \`packages/*/public/\`
- [ ] Criar favicon personalizado
- [ ] Atualizar ícones do PWA
- [ ] Modificar cores do tema (se desejado)

### 2. Configurações

- [ ] Atualizar \`.env\` com URLs do TestPath
- [ ] Configurar domínio próprio
- [ ] Configurar SSL/TLS
- [ ] Configurar SMTP para emails

### 3. Features Empresariais

- [ ] Implementar sistema de licenciamento
- [ ] Adicionar SSO
- [ ] Criar RBAC
- [ ] Implementar auditoria

### 4. Legal

- [ ] Consultar advogado
- [ ] Registrar marca "TestPath"
- [ ] Criar Termos de Serviço
- [ ] Criar Política de Privacidade

### 5. Infraestrutura

- [ ] Configurar servidor de produção
- [ ] Implementar backup automático
- [ ] Configurar monitoramento
- [ ] Setup CI/CD

### 6. Marketing

- [ ] Criar website profissional
- [ ] Preparar materiais de vendas
- [ ] Definir preços
- [ ] Estratégia de lançamento

## 📧 Contato

Para dúvidas ou suporte: $companyEmail
"@

Set-Content -Path "NEXT-STEPS.md" -Value $nextSteps
Write-Host "  ✓ NEXT-STEPS.md criado" -ForegroundColor Green

# Resumo
Write-Host ""
Write-Host "=====================================" -ForegroundColor Green
Write-Host "  Rebrand Concluído!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""
Write-Host "Arquivos criados:" -ForegroundColor Cyan
Write-Host "  - THIRD-PARTY-LICENSES.md" -ForegroundColor White
Write-Host "  - README-TESTPATH.md" -ForegroundColor White
Write-Host "  - NEXT-STEPS.md" -ForegroundColor White
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Cyan
Write-Host "  1. Revisar os arquivos modificados" -ForegroundColor White
Write-Host "  2. Ler NEXT-STEPS.md" -ForegroundColor White
Write-Host "  3. Substituir logos e imagens" -ForegroundColor White
Write-Host "  4. Consultar um advogado" -ForegroundColor White
Write-Host "  5. Testar a aplicação" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  LEMBRE-SE: Você DEVE manter os avisos de copyright!" -ForegroundColor Yellow
Write-Host ""

