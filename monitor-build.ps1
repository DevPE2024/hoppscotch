# Script de Monitoramento do Build Docker
Write-Host "=== Monitor de Build do Hoppscotch ===" -ForegroundColor Cyan
Write-Host ""

$startTime = Get-Date

while ($true) {
    Clear-Host
    Write-Host "=== Monitor de Build do Hoppscotch ===" -ForegroundColor Cyan
    Write-Host "Tempo decorrido: $((Get-Date) - $startTime)" -ForegroundColor Yellow
    Write-Host ""
    
    Write-Host "--- Imagens Criadas ---" -ForegroundColor Green
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}" | Select-String -Pattern "hoppscotch|testpath|REPOSITORY"
    Write-Host ""
    
    Write-Host "--- Containers ---" -ForegroundColor Green
    docker ps -a --filter "name=hoppscotch" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    Write-Host ""
    
    Write-Host "--- Status do Profile Dev ---" -ForegroundColor Green
    docker compose --profile dev ps
    Write-Host ""
    
    Write-Host "Pressione Ctrl+C para sair do monitor" -ForegroundColor Gray
    Write-Host "Atualizando em 15 segundos..." -ForegroundColor Gray
    
    Start-Sleep -Seconds 15
}

