# Status do Ambiente de Desenvolvimento - Hoppscotch

✅ **APLICAÇÃO RODANDO COM SUCESSO!**

## 🎉 Containers Ativos

| Container | Status | Portas | Descrição |
|-----------|--------|--------|-----------|
| `hoppscotch-aio-dev` | ✅ HEALTHY | 4010, 3101, 3171, 3201, 3081 | All-in-One Development |
| `hoppscotch-backend` | ✅ UP | 3170, 3180 | Backend API |
| `hoppscotch-app` | ✅ UP | 3000, 3200, 3080 | Frontend Application |
| `hoppscotch-sh-admin` | ✅ UP | 3100, 3280 | Admin Dashboard |
| `hoppscotch-db-1` | ✅ HEALTHY | 5432 | PostgreSQL Database |
| `hoppscotch-migrate-1` | ✅ EXITED (0) | - | Migrações Concluídas |

## 🌐 URLs de Acesso

### Ambiente de Desenvolvimento Principal (AIO-Dev)
- **Frontend Application**: http://localhost:4010
- **Backend API**: http://localhost:3171/graphql
- **Admin Dashboard**: http://localhost:3101
- **Webapp Server**: http://localhost:3201

### Serviços Individuais
- **Frontend App**: http://localhost:3000
- **Backend API**: http://localhost:3170/graphql
- **Admin Dashboard**: http://localhost:3100
- **Webapp Server**: http://localhost:3200

## 📊 Estatísticas de Build

### Imagens Criadas
- `testpath-hoppscotch-aio-dev` - 1.25GB
- `testpath-hoppscotch-backend` - 1.09GB
- `testpath-hoppscotch-migrate` - 1.09GB
- `testpath-hoppscotch-app` - 542MB
- `testpath-hoppscotch-sh-admin` - 398MB

**Total de espaço utilizado**: ~4.36GB

### Tempo de Build (Primeira Execução)
- Aproximadamente **10-15 minutos**
- Builds subsequentes serão muito mais rápidos (uso de cache)

## 🔧 Comandos Úteis

### Verificar Status
```powershell
docker compose --profile dev ps
```

### Ver Logs em Tempo Real
```powershell
# Todos os serviços
docker compose --profile dev logs -f

# Serviço específico
docker logs -f hoppscotch-backend
docker logs -f hoppscotch-app
docker logs -f hoppscotch-aio-dev
```

### Reiniciar Serviços
```powershell
# Reiniciar todos
docker compose --profile dev restart

# Reiniciar específico
docker compose restart hoppscotch-backend
docker compose restart hoppscotch-app
```

### Parar Ambiente
```powershell
docker compose --profile dev down
```

### Rebuild (após mudanças)
```powershell
docker compose --profile dev up -d --build
```

## 📁 Hot-Reload Ativado

Os seguintes diretórios estão montados com volumes para hot-reload:

- `./packages/hoppscotch-backend/` → Backend com hot-reload
- `./packages/hoppscotch-selfhost-web/` → Frontend com hot-reload
- `./packages/hoppscotch-sh-admin/` → Admin com hot-reload

**Importante**: Alterações nos arquivos serão refletidas automaticamente!

## ⚠️ Observações

### Avisos do Banco de Dados
Os erros `relation "public.InfraConfig" does not exist` são normais durante a inicialização e serão resolvidos automaticamente pelas migrações.

### Modo de Desenvolvimento
- Hot-reload ativado
- Debug logs habilitados
- Volumes montados para desenvolvimento ágil

## 🚀 Próximos Passos

1. **Acesse a aplicação**: http://localhost:4010
2. **Configure um usuário admin** (se necessário)
3. **Comece a desenvolver!**

## 📚 Recursos Adicionais

- Documentação completa: arquivo `PRIORIDADE.md`
- Comandos Docker: veja `PRIORIDADE.md`
- Estrutura do projeto: arquivo `README.md`

---

**Data de Inicialização**: 09/10/2025, 13:28
**Modo**: Desenvolvimento
**Profile**: `dev`
**Status**: ✅ OPERACIONAL

