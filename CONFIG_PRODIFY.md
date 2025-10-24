# 🔐 CONFIGURAÇÃO DA INTEGRAÇÃO COM PRODIFY

## ⚠️ IMPORTANTE: Adicione estas variáveis ao arquivo `.env`

Copie e cole no arquivo `TestPath/.env`:

```ini
# ============================================
# INTEGRAÇÃO COM PRODIFY
# ============================================

# Banco de Dados Prodify (para validação de usuários)
PRODIFY_DB_URL=postgresql://postgres:password@localhost:8010/super_productive

# URL do Prodify (para redirects)
PRODIFY_URL=http://localhost:8001

# JWT Secret do Prodify (deve ser o mesmo do Prodify)
PRODIFY_JWT_SECRET=your-secret-key
NEXTAUTH_SECRET=your-secret-key

# ============================================
# ECOSSISTEMA AFFINIFY
# ============================================

# URLs dos outros apps
ECOSYSTEM_PRODIFY_URL=http://localhost:8001
ECOSYSTEM_ONSCOPE_URL=http://localhost:8002  
ECOSYSTEM_JAZZUP_URL=http://localhost:5173
ECOSYSTEM_DEEPQUEST_URL=http://localhost:3001
ECOSYSTEM_OPENUIX_URL=http://localhost:5050
ECOSYSTEM_TESTPATH_URL=http://localhost:3000
```

## 📝 IMPORTANTE:

1. O `PRODIFY_JWT_SECRET` deve ser o MESMO configurado no Prodify
2. O `PRODIFY_DB_URL` aponta para o banco do Prodify (porta 8010)
3. Adicione `http://localhost:8001` no `WHITELISTED_ORIGINS`

---

**Criado:** 23/10/2025

