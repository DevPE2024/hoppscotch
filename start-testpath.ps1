# ============================================
# TESTPATH - Script de Inicialização Automática
# ============================================
# Este script inicia e monitora:
# - Banco de Dados PostgreSQL (Docker)
# - Backend NestJS (porta 3170)
# - Frontend Vue.js (porta 3000)
# ============================================

param(
    [switch]$SkipDatabaseCheck = $false,
    [switch]$Verbose = $false
)

# Cores para output
$Host.UI.RawUI.ForegroundColor = "White"
$ErrorActionPreference = "Stop"

# ============================================
# FUNÇÕES AUXILIARES
# ============================================

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White",
        [string]$Icon = ""
    )
    
    $prevColor = $Host.UI.RawUI.ForegroundColor
    $Host.UI.RawUI.ForegroundColor = $Color
    
    if ($Icon) {
        Write-Host "$Icon $Message"
    } else {
        Write-Host $Message
    }
    
    $Host.UI.RawUI.ForegroundColor = $prevColor
}

function Write-Header {
    param([string]$Title)
    
    Write-Host ""
    Write-ColorOutput "============================================" "Cyan"
    Write-ColorOutput $Title "Cyan"
    Write-ColorOutput "============================================" "Cyan"
    Write-Host ""
}

function Test-Port {
    param(
        [int]$Port,
        [string]$ServiceName
    )
    
    $connection = Test-NetConnection -ComputerName localhost -Port $Port -WarningAction SilentlyContinue -InformationLevel Quiet
    return $connection
}

function Wait-ForPort {
    param(
        [int]$Port,
        [string]$ServiceName,
        [int]$MaxWaitSeconds = 60
    )
    
    Write-ColorOutput "⏳ Aguardando $ServiceName na porta $Port..." "Yellow"
    
    $elapsed = 0
    while ($elapsed -lt $MaxWaitSeconds) {
        if (Test-Port -Port $Port -ServiceName $ServiceName) {
            Write-ColorOutput "✅ $ServiceName está disponível!" "Green"
            return $true
        }
        
        Start-Sleep -Seconds 2
        $elapsed += 2
        
        if ($Verbose) {
            Write-Host "... aguardando ($elapsed/$MaxWaitSeconds segundos)"
        }
    }
    
    Write-ColorOutput "❌ Timeout esperando $ServiceName na porta $Port" "Red"
    return $false
}

function Test-DatabaseContainer {
    $container = docker ps --filter "name=testpath-db-dev" --format "{{.Names}}"
    
    if ($container -eq "testpath-db-dev") {
        Write-ColorOutput "✅ Container testpath-db-dev está rodando" "Green"
        return $true
    } else {
        Write-ColorOutput "❌ Container testpath-db-dev NÃO está rodando" "Red"
        return $false
    }
}

function Start-DatabaseContainer {
    Write-ColorOutput "🚀 Iniciando container PostgreSQL..." "Cyan"
    
    # Verificar se o container existe
    $containerExists = docker ps -a --filter "name=testpath-db-dev" --format "{{.Names}}"
    
    if ($containerExists -eq "testpath-db-dev") {
        Write-ColorOutput "📦 Container encontrado, iniciando..." "Yellow"
        docker start testpath-db-dev | Out-Null
    } else {
        Write-ColorOutput "📦 Container não encontrado, criando..." "Yellow"
        
        # Verificar se o docker-compose existe
        $dockerComposePath = Join-Path (Get-Location).Path "../docker-compose.fase1.yml"
        
        if (Test-Path $dockerComposePath) {
            docker-compose -f $dockerComposePath up -d testpath-db
        } else {
            Write-ColorOutput "❌ Arquivo docker-compose.fase1.yml não encontrado em: $dockerComposePath" "Red"
            Write-ColorOutput "Por favor, certifique-se de que o arquivo docker-compose está no local correto." "Red"
            exit 1
        }
    }
    
    # Aguardar o banco estar pronto
    Start-Sleep -Seconds 5
    
    # Verificar se está rodando
    if (Wait-ForPort -Port 7001 -ServiceName "PostgreSQL" -MaxWaitSeconds 30) {
        Write-ColorOutput "✅ PostgreSQL iniciado com sucesso!" "Green"
        return $true
    } else {
        Write-ColorOutput "❌ Falha ao iniciar PostgreSQL" "Red"
        return $false
    }
}

function Test-EnvironmentFile {
    $envPath = Join-Path (Get-Location).Path ".env"
    
    if (Test-Path $envPath) {
        Write-ColorOutput "✅ Arquivo .env encontrado" "Green"
        return $true
    } else {
        Write-ColorOutput "❌ Arquivo .env NÃO encontrado" "Red"
        Write-ColorOutput "Por favor, crie o arquivo .env com as variáveis necessárias." "Yellow"
        return $false
    }
}

function Test-Dependencies {
    Write-ColorOutput "🔍 Verificando dependências Node.js..." "Cyan"
    
    $nodeModulesBackend = Test-Path "packages/hoppscotch-backend/node_modules"
    $nodeModulesFrontend = Test-Path "packages/hoppscotch-selfhost-web/node_modules"
    
    if ($nodeModulesBackend -and $nodeModulesFrontend) {
        Write-ColorOutput "✅ Dependências instaladas" "Green"
        return $true
    } else {
        Write-ColorOutput "❌ Dependências NÃO instaladas" "Red"
        Write-ColorOutput "Execute: pnpm install" "Yellow"
        return $false
    }
}

function Start-Backend {
    Write-ColorOutput "🚀 Iniciando Backend NestJS..." "Cyan"
    
    $backendPath = Join-Path (Get-Location).Path "packages\hoppscotch-backend"
    
    if (-not (Test-Path $backendPath)) {
        Write-ColorOutput "❌ Diretório backend não encontrado: $backendPath" "Red"
        return $null
    }
    
    # Iniciar backend em background
    $backendJob = Start-Job -ScriptBlock {
        param($path)
        Set-Location $path
        pnpm run start:dev
    } -ArgumentList $backendPath
    
    # Aguardar backend estar pronto
    if (Wait-ForPort -Port 3170 -ServiceName "Backend" -MaxWaitSeconds 60) {
        Write-ColorOutput "✅ Backend iniciado com sucesso!" "Green"
        return $backendJob
    } else {
        Write-ColorOutput "❌ Falha ao iniciar Backend" "Red"
        Stop-Job -Job $backendJob -ErrorAction SilentlyContinue
        Remove-Job -Job $backendJob -ErrorAction SilentlyContinue
        return $null
    }
}

function Start-Frontend {
    Write-ColorOutput "🚀 Iniciando Frontend Vue.js..." "Cyan"
    
    $frontendPath = Join-Path (Get-Location).Path "packages\hoppscotch-selfhost-web"
    
    if (-not (Test-Path $frontendPath)) {
        Write-ColorOutput "❌ Diretório frontend não encontrado: $frontendPath" "Red"
        return $null
    }
    
    # Iniciar frontend em background
    $frontendJob = Start-Job -ScriptBlock {
        param($path)
        Set-Location $path
        pnpm run dev
    } -ArgumentList $frontendPath
    
    # Aguardar frontend estar pronto
    if (Wait-ForPort -Port 3000 -ServiceName "Frontend" -MaxWaitSeconds 60) {
        Write-ColorOutput "✅ Frontend iniciado com sucesso!" "Green"
        return $frontendJob
    } else {
        Write-ColorOutput "❌ Falha ao iniciar Frontend" "Red"
        Stop-Job -Job $frontendJob -ErrorAction SilentlyContinue
        Remove-Job -Job $frontendJob -ErrorAction SilentlyContinue
        return $null
    }
}

function Monitor-Services {
    param(
        [System.Management.Automation.Job]$BackendJob,
        [System.Management.Automation.Job]$FrontendJob
    )
    
    Write-Header "MONITORAMENTO ATIVO"
    Write-ColorOutput "Pressione Ctrl+C para parar todos os serviços" "Yellow"
    Write-Host ""
    
    $iteration = 0
    
    try {
        while ($true) {
            $iteration++
            
            # Verificar a cada 10 segundos
            Start-Sleep -Seconds 10
            
            # Verificar status dos serviços
            $dbRunning = Test-DatabaseContainer
            $backendRunning = Test-Port -Port 3170 -ServiceName "Backend"
            $frontendRunning = Test-Port -Port 3000 -ServiceName "Frontend"
            
            if ($Verbose -or ($iteration % 6 -eq 0)) {  # A cada minuto ou em verbose
                Write-Host ""
                Write-ColorOutput "📊 Status dos Serviços ($(Get-Date -Format 'HH:mm:ss')):" "Cyan"
                
                if ($dbRunning) {
                    Write-ColorOutput "  ✅ PostgreSQL (porta 7001): Rodando" "Green"
                } else {
                    Write-ColorOutput "  ❌ PostgreSQL (porta 7001): Parado" "Red"
                }
                
                if ($backendRunning) {
                    Write-ColorOutput "  ✅ Backend (porta 3170): Rodando" "Green"
                } else {
                    Write-ColorOutput "  ❌ Backend (porta 3170): Parado" "Red"
                }
                
                if ($frontendRunning) {
                    Write-ColorOutput "  ✅ Frontend (porta 3000): Rodando" "Green"
                } else {
                    Write-ColorOutput "  ❌ Frontend (porta 3000): Parado" "Red"
                }
                
                Write-Host ""
            }
            
            # Se algum serviço parou, alertar
            if (-not $dbRunning -or -not $backendRunning -or -not $frontendRunning) {
                Write-ColorOutput "⚠️  ALERTA: Um ou mais serviços pararam!" "Red"
                
                if (-not $dbRunning) {
                    Write-ColorOutput "   🔴 PostgreSQL parou - Tentando reiniciar..." "Red"
                    Start-DatabaseContainer | Out-Null
                }
                
                if (-not $backendRunning) {
                    Write-ColorOutput "   🔴 Backend parou - Verifique os logs" "Red"
                }
                
                if (-not $frontendRunning) {
                    Write-ColorOutput "   🔴 Frontend parou - Verifique os logs" "Red"
                }
            }
        }
    }
    catch {
        Write-ColorOutput "⚠️  Monitoramento interrompido" "Yellow"
    }
    finally {
        # Cleanup ao sair
        Write-Host ""
        Write-ColorOutput "🛑 Parando serviços..." "Yellow"
        
        if ($BackendJob) {
            Stop-Job -Job $BackendJob -ErrorAction SilentlyContinue
            Remove-Job -Job $BackendJob -ErrorAction SilentlyContinue
        }
        
        if ($FrontendJob) {
            Stop-Job -Job $FrontendJob -ErrorAction SilentlyContinue
            Remove-Job -Job $FrontendJob -ErrorAction SilentlyContinue
        }
        
        Write-ColorOutput "✅ Serviços parados com sucesso!" "Green"
    }
}

# ============================================
# SCRIPT PRINCIPAL
# ============================================

Clear-Host

Write-Header "TESTPATH - Inicialização Automática"

Write-ColorOutput "📅 Data: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')" "Cyan"
Write-ColorOutput "📂 Diretório: $(Get-Location)" "Cyan"
Write-Host ""

# Verificar se estamos no diretório correto
if (-not (Test-Path "packages")) {
    Write-ColorOutput "❌ ERRO: Execute este script no diretório raiz do TestPath" "Red"
    Write-ColorOutput "Diretório atual: $(Get-Location)" "Yellow"
    exit 1
}

# ============================================
# ETAPA 1: VERIFICAÇÕES PRÉ-INICIALIZAÇÃO
# ============================================

Write-Header "ETAPA 1: Verificações Pré-Inicialização"

# 1.1 Verificar arquivo .env
if (-not (Test-EnvironmentFile)) {
    Write-ColorOutput "❌ ERRO: Arquivo .env não encontrado" "Red"
    exit 1
}

# 1.2 Verificar dependências
if (-not (Test-Dependencies)) {
    Write-ColorOutput "❌ ERRO: Dependências não instaladas" "Red"
    Write-ColorOutput "Execute: pnpm install" "Yellow"
    exit 1
}

# 1.3 Verificar Docker
try {
    docker --version | Out-Null
    Write-ColorOutput "✅ Docker disponível" "Green"
} catch {
    Write-ColorOutput "❌ ERRO: Docker não está instalado ou não está rodando" "Red"
    exit 1
}

# ============================================
# ETAPA 2: INICIAR BANCO DE DADOS
# ============================================

Write-Header "ETAPA 2: Banco de Dados PostgreSQL"

if (-not $SkipDatabaseCheck) {
    if (-not (Test-DatabaseContainer)) {
        Write-ColorOutput "⚠️  Banco de dados não está rodando" "Yellow"
        
        $response = Read-Host "Deseja iniciar o banco de dados agora? (S/N)"
        
        if ($response -eq "S" -or $response -eq "s" -or $response -eq "") {
            if (-not (Start-DatabaseContainer)) {
                Write-ColorOutput "❌ ERRO: Falha ao iniciar banco de dados" "Red"
                Write-ColorOutput "SOLUÇÃO: Execute manualmente:" "Yellow"
                Write-ColorOutput "  docker-compose -f ../docker-compose.fase1.yml up -d testpath-db" "Cyan"
                exit 1
            }
        } else {
            Write-ColorOutput "❌ ERRO: Banco de dados é obrigatório para a aplicação funcionar" "Red"
            exit 1
        }
    } else {
        Write-ColorOutput "✅ Banco de dados já está rodando" "Green"
    }
} else {
    Write-ColorOutput "⚠️  Verificação de banco de dados ignorada (--SkipDatabaseCheck)" "Yellow"
}

# ============================================
# ETAPA 3: INICIAR BACKEND
# ============================================

Write-Header "ETAPA 3: Backend NestJS"

$backendJob = Start-Backend

if ($null -eq $backendJob) {
    Write-ColorOutput "❌ ERRO: Falha ao iniciar Backend" "Red"
    exit 1
}

# ============================================
# ETAPA 4: INICIAR FRONTEND
# ============================================

Write-Header "ETAPA 4: Frontend Vue.js"

$frontendJob = Start-Frontend

if ($null -eq $frontendJob) {
    Write-ColorOutput "❌ ERRO: Falha ao iniciar Frontend" "Red"
    
    # Parar backend se frontend falhou
    Stop-Job -Job $backendJob -ErrorAction SilentlyContinue
    Remove-Job -Job $backendJob -ErrorAction SilentlyContinue
    
    exit 1
}

# ============================================
# ETAPA 5: RESUMO E URLS
# ============================================

Write-Header "APLICAÇÃO INICIADA COM SUCESSO!"

Write-ColorOutput "✅ Todos os serviços estão rodando!" "Green"
Write-Host ""
Write-ColorOutput "📍 URLs Disponíveis:" "Cyan"
Write-ColorOutput "  🌐 Frontend:           http://localhost:3000" "White"
Write-ColorOutput "  ⚙️  Backend API:        http://localhost:3170" "White"
Write-ColorOutput "  🔌 GraphQL Playground: http://localhost:3170/graphql" "White"
Write-ColorOutput "  🗄️  PostgreSQL:         localhost:7001" "White"
Write-Host ""
Write-ColorOutput "📊 Credenciais do Banco:" "Cyan"
Write-ColorOutput "  Usuário: postgres" "White"
Write-ColorOutput "  Senha:   testpass" "White"
Write-ColorOutput "  Database: hoppscotch" "White"
Write-Host ""

# ============================================
# ETAPA 6: MONITORAMENTO
# ============================================

Monitor-Services -BackendJob $backendJob -FrontendJob $frontendJob

Write-Host ""
Write-ColorOutput "👋 Aplicação encerrada!" "Cyan"

