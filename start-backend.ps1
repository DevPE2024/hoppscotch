# Script para iniciar o Backend do TestPath
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Iniciando Backend do TestPath" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Navegar para o diretório do backend
Set-Location -Path "C:\App\Deployer\Project_Affinify\TestPath\packages\hoppscotch-backend"

Write-Host "Diretório atual: $(Get-Location)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Verificando banco de dados..." -ForegroundColor Green

# Testar conexão com o banco
$dbTest = docker exec testpath-db-dev pg_isready -U postgres
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Banco de dados está rodando!" -ForegroundColor Green
} else {
    Write-Host "✗ Banco de dados não está acessível!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Iniciando servidor backend na porta 3170..." -ForegroundColor Green
Write-Host "Aguarde, o servidor está carregando..." -ForegroundColor Yellow
Write-Host ""

# Iniciar o servidor
pnpm run start:dev

