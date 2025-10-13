# Comandos Docker - Gestão de Volumes TestPath

**Data**: 09/10/2025

---

## 🎯 COMANDOS PARA REMOÇÃO DE VOLUMES

### ✅ Remover Volumes da Aplicação TestPath (Específico)

```bash
# Parar e remover volumes do ambiente de desenvolvimento
docker compose --profile dev down -v

# Parar e remover volumes do ambiente de produção  
docker compose --profile prod down -v

# Parar e remover volumes do ambiente padrão (AIO)
docker compose --profile default down -v
```

**O que faz:**
- ✅ Remove **APENAS** os volumes desta aplicação TestPath
- ✅ Preserva volumes de outras aplicações Docker
- ✅ Remove dados do PostgreSQL, logs, etc.
- ✅ Limpa completamente o ambiente

---

## ⚠️ COMANDOS PERIGOSOS (NÃO USAR)

```bash
# ❌ PERIGOSO - Remove TODOS os volumes do Docker
docker system prune -a --volumes

# ❌ PERIGOSO - Remove volumes não utilizados de TODAS as aplicações
docker volume prune
```

**Por que evitar:**
- ❌ Remove volumes de outras aplicações
- ❌ Pode quebrar outros projetos Docker
- ❌ Perda de dados irreversível

---

## 🔍 VERIFICAR VOLUMES

### Listar Volumes Existentes:
```bash
# Ver todos os volumes Docker
docker volume ls

# Ver volumes específicos do TestPath
docker volume ls | grep testpath
```

### Verificar Uso de Volumes:
```bash
# Ver informações detalhadas dos volumes
docker volume inspect <nome_do_volume>

# Ver espaço usado pelos volumes
docker system df -v
```

---

## 📊 VOLUMES CRIADOS PELO TESTPATH

### Volumes Automáticos:
```
testpath_default_postgres_data    # Dados do PostgreSQL
testpath_default_postgres_logs    # Logs do PostgreSQL
```

### O que é Removido com `-v`:
- ✅ **Banco de dados**: Todas as coleções, requisições, usuários
- ✅ **Logs**: Histórico de execução
- ✅ **Cache**: Dados temporários
- ✅ **Configurações**: Settings locais

### O que NÃO é Removido:
- ✅ **Imagens Docker**: Permanecem para rebuilds rápidos
- ✅ **Código-fonte**: Seus arquivos locais
- ✅ **Outras aplicações**: Volumes de outros projetos

---

## 🚀 CENÁRIOS DE USO

### 1. Limpeza Completa (Reset Total)
```bash
# Parar aplicação
docker compose --profile default down -v

# Rebuild completo
docker compose --profile default up -d --build
```
**Resultado**: Aplicação como se fosse a primeira instalação

### 2. Parada Simples (Preservar Dados)
```bash
# Parar sem remover volumes
docker compose --profile default down

# Reiniciar com dados preservados
docker compose --profile default up -d
```
**Resultado**: Dados preservados, aplicação reiniciada

### 3. Rebuild com Dados Preservados
```bash
# Parar aplicação
docker compose --profile default down

# Rebuild sem remover dados
docker compose --profile default up -d --build
```
**Resultado**: Código atualizado, dados preservados

---

## 🛡️ BACKUP ANTES DE REMOVER VOLUMES

### Fazer Backup dos Dados:
```bash
# Criar backup do volume PostgreSQL
docker run --rm -v testpath_default_postgres_data:/data -v $(pwd):/backup alpine tar czf /backup/postgres-backup.tar.gz -C /data .

# Restaurar backup (se necessário)
docker run --rm -v testpath_default_postgres_data:/data -v $(pwd):/backup alpine tar xzf /backup/postgres-backup.tar.gz -C /data
```

---

## 📋 CHECKLIST DE SEGURANÇA

### Antes de Remover Volumes:
- [ ] Fazer backup dos dados importantes
- [ ] Confirmar que é a aplicação TestPath
- [ ] Verificar se não há outros projetos usando volumes
- [ ] Ter certeza que quer remover os dados

### Comando Seguro:
```bash
# SEMPRE use o perfil específico
docker compose --profile default down -v
# ✅ Remove apenas volumes do TestPath
```

### Comando Perigoso:
```bash
# NUNCA use sem especificar aplicação
docker system prune -a --volumes
# ❌ Remove volumes de TODAS as aplicações
```

---

## 🎯 RESUMO PRÁTICO

### Para Reset Completo:
```bash
docker compose --profile default down -v
docker compose --profile default up -d --build
```

### Para Preservar Dados:
```bash
docker compose --profile default down
docker compose --profile default up -d
```

### Para Verificar Status:
```bash
docker compose --profile default ps
docker volume ls | grep testpath
```

---

## ⚡ COMANDOS RÁPIDOS

```bash
# Reset completo (remove tudo)
docker compose --profile default down -v && docker compose --profile default up -d --build

# Restart simples (preserva dados)
docker compose --profile default restart

# Ver status
docker compose --profile default ps
```

---

**✅ SEGURO**: `docker compose --profile default down -v`
**❌ PERIGOSO**: `docker system prune -a --volumes`

**Use sempre o comando com perfil específico para remover apenas os volumes do TestPath!**
