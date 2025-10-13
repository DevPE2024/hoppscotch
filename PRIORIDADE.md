# Prioridades para Execução do Projeto Hoppscotch

Este documento descreve as prioridades e requisitos necessários para a execução do projeto Hoppscotch, bem como os comandos Docker para gerenciar os ambientes de desenvolvimento e produção.

## Requisitos Necessários

### 1. Requisitos de Sistema

- **Docker**: Versão 20.10.0 ou superior
- **Docker Compose**: Versão 2.0.0 ou superior
- **Memória RAM**: Mínimo de 4GB (recomendado 8GB)
- **Espaço em Disco**: Mínimo de 2GB para imagens e volumes
- **CPU**: 2 cores ou mais

### 2. Requisitos de Rede

- Portas disponíveis:
  - 3000-3200: Utilizadas pelos serviços Hoppscotch
  - 5432: PostgreSQL
  - 80: Servidor web Caddy

### 3. Configuração de Ambiente

É necessário criar um arquivo `.env` na raiz do projeto com as seguintes variáveis:

```
# Configurações do Banco de Dados
DATABASE_URL=postgresql://postgres:testpass@hoppscotch-db:5432/hoppscotch?connect_timeout=300

# Configurações da Aplicação
PORT=8080
PRODUCTION=true

# Configurações de Autenticação (opcional)
# AUTH_SECRET=seu_segredo_aqui
# GOOGLE_CLIENT_ID=seu_client_id_google
# GOOGLE_CLIENT_SECRET=seu_client_secret_google
# GITHUB_CLIENT_ID=seu_client_id_github
# GITHUB_CLIENT_SECRET=seu_client_secret_github

# Configurações de Email (opcional)
# MAILER_HOST=smtp.example.com
# MAILER_PORT=587
# MAILER_USER=seu_usuario
# MAILER_PASS=sua_senha
# MAILER_FROM=noreply@example.com

# Configurações de Subpath (opcional)
# ENABLE_SUBPATH_BASED_ACCESS=true
```

## Comandos Docker

### Gerenciamento de Ambientes

#### Ambiente de Desenvolvimento

```bash
# Iniciar ambiente de desenvolvimento com hot-reload
docker compose --profile dev up -d

# Parar ambiente de desenvolvimento
docker compose --profile dev down

# Parar ambiente de desenvolvimento E remover volumes desta aplicação (remove dados do TestPath)
docker compose --profile dev down -v

# Reiniciar ambiente de desenvolvimento
docker compose --profile dev restart

# Ver logs do ambiente de desenvolvimento
docker compose --profile dev logs -f
```

#### Ambiente de Produção

```bash
# Iniciar ambiente de produção
docker compose --profile prod up -d

# Parar ambiente de produção
docker compose --profile prod down

# Parar ambiente de produção E remover volumes desta aplicação (remove dados do TestPath)
docker compose --profile prod down -v

# Reiniciar ambiente de produção
docker compose --profile prod restart

# Ver logs do ambiente de produção
docker compose --profile prod logs -f
```

### Comandos para Serviços Específicos

```bash
# Reiniciar apenas o backend
docker compose restart hoppscotch-backend

# Reiniciar apenas a aplicação web
docker compose restart hoppscotch-app

# Reiniciar apenas o painel admin
docker compose restart hoppscotch-sh-admin

# Reiniciar apenas o banco de dados
docker compose restart hoppscotch-db
```

### Comandos para Gerenciamento de Dados

```bash
# Backup do banco de dados
docker exec -t hoppscotch-db pg_dump -U postgres hoppscotch > backup_$(date +%Y%m%d_%H%M%S).sql

# Restaurar backup do banco de dados
cat backup_file.sql | docker exec -i hoppscotch-db psql -U postgres -d hoppscotch
```

### Comandos para Manutenção

```bash
# Limpar volumes não utilizados
docker volume prune

# Limpar imagens não utilizadas
docker image prune

# Verificar status dos containers
docker ps -a

# Verificar logs de um container específico
docker logs -f [nome_do_container]

# Acessar shell dentro de um container
docker exec -it [nome_do_container] sh
```

## Portas Utilizadas

| Serviço | Porta (Produção) | Porta (Desenvolvimento) |
|---------|------------------|-------------------------|
| Frontend (App) | 3000 | 4010 |
| Backend API | 3170 | 3171 |
| Admin Dashboard | 3100 | 3101 |
| Webapp Server | 3200 | 3201 |
| Caddy Server | 3080 | 3081 |
| PostgreSQL | 5432 | 5432 |

## Ordem de Inicialização

Para garantir o correto funcionamento da aplicação, os serviços devem ser inicializados na seguinte ordem:

1. Banco de dados (PostgreSQL)
2. Migrações do banco de dados
3. Backend
4. Frontend e Admin Dashboard

Utilizando os perfis `dev` ou `prod` no Docker Compose, essa ordem é automaticamente respeitada através das dependências configuradas.

## Solução de Problemas

### Banco de Dados não Inicializa

Verifique se o volume do PostgreSQL está correto:

```bash
docker volume ls
docker volume inspect project_affinify_testpath_postgres_data
```

### Aplicação Não Conecta ao Backend

Verifique se o backend está em execução e acessível:

```bash
docker logs hoppscotch-backend
curl http://localhost:3170/api/health
```

### Erro de Migração do Banco de Dados

Execute manualmente as migrações:

```bash
docker exec -it hoppscotch-backend sh -c "pnpx prisma migrate deploy"
```

## Monitoramento

Para monitorar o uso de recursos dos containers:

```bash
docker stats
```

## Backup e Restauração

É recomendado fazer backup regular do volume do banco de dados:

```bash
# Backup do volume
docker run --rm -v project_affinify_testpath_postgres_data:/source -v $(pwd):/backup alpine tar -czf /backup/postgres_data_backup.tar.gz -C /source .

# Restauração do volume
docker run --rm -v project_affinify_testpath_postgres_data:/target -v $(pwd):/backup alpine sh -c "rm -rf /target/* && tar -xzf /backup/postgres_data_backup.tar.gz -C /target"
```

---

Este documento deve ser mantido atualizado conforme as necessidades do projeto evoluem.
