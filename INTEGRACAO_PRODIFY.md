# 🔐 INTEGRAÇÃO TESTPATH ↔ PRODIFY

## 📋 RESUMO

Integração completa de autenticação SSO entre Prodify e TestPath usando JWT.

---

## ✅ O QUE FOI IMPLEMENTADO

### **1. Backend - Autenticação JWT**

**Arquivos criados:**
- `packages/hoppscotch-backend/src/auth/prodify-auth.strategy.ts`
- `packages/hoppscotch-backend/src/auth/prodify-auth.controller.ts`

**Arquivos modificados:**
- `packages/hoppscotch-backend/src/auth/auth.module.ts`

**Endpoints criados:**
- `GET /v1/auth/prodify` - Recebe token SSO e autentica
- `GET /v1/auth/prodify/validate` - Valida sessão existente
- `GET /v1/auth/prodify/logout` - Logout e redirect para Prodify

---

### **2. Frontend - Ícone do Ecossistema**

**Arquivos criados:**
- `packages/hoppscotch-common/src/components/app/EcosystemPopup.vue`

**Arquivos modificados:**
- `packages/hoppscotch-common/src/components/app/Header.vue`
  - Adicionado ícone Grid 3x3 (ecossistema)
  - Popup com todos os apps do ecossistema

---

## 🔧 CONFIGURAÇÃO NECESSÁRIA

### **Passo 1: Atualizar `.env`**

Adicione no arquivo `TestPath/.env`:

```ini
# Integração com Prodify
PRODIFY_DB_URL=postgresql://postgres:password@localhost:8010/super_productive
PRODIFY_URL=http://localhost:8001
PRODIFY_JWT_SECRET=your-secret-key
NEXTAUTH_SECRET=your-secret-key

# Ecossistema
ECOSYSTEM_PRODIFY_URL=http://localhost:8001
ECOSYSTEM_ONSCOPE_URL=http://localhost:8002
ECOSYSTEM_JAZZUP_URL=http://localhost:5173
ECOSYSTEM_DEEPQUEST_URL=http://localhost:3001
ECOSYSTEM_OPENUIX_URL=http://localhost:5050
ECOSYSTEM_TESTPATH_URL=http://localhost:3000
```

**⚠️ IMPORTANTE:** O `PRODIFY_JWT_SECRET` deve ser o MESMO do Prodify!

---

### **Passo 2: Atualizar `WHITELISTED_ORIGINS`**

No mesmo arquivo `.env`, adicione o Prodify nas origens permitidas:

```ini
WHITELISTED_ORIGINS=http://localhost:3000,http://localhost:3100,http://localhost:3170,http://localhost:8001
```

---

### **Passo 3: Atualizar Prodify**

No arquivo `Prodify/super_productive-desh/components/dashboard/EcosystemPopup.tsx`:

Já existe a configuração para TestPath:
```typescript
{
  name: "TestPath",
  description: "API Testing Tool",
  url: "http://localhost:3000",
  gradient: "from-teal-400 via-pink-400 to-purple-400",
  icon: "T"
}
```

**Modificar a função `handleAppClick` para incluir TestPath:**

```typescript
// Adicionar antes do final da função handleAppClick
if (appName === 'TestPath') {
  try {
    const userDataStr = localStorage.getItem('user_data');
    const authToken = localStorage.getItem('auth_token');
    
    let userEmail: string | null = null;
    
    if (userDataStr) {
      try {
        const userData = JSON.parse(userDataStr);
        userEmail = userData.email;
      } catch (e) {
        console.error('Erro ao parsear user_data:', e);
      }
    }
    
    if (userEmail && authToken) {
      // Criar token SSO
      const ssoData = {
        email: userEmail,
        timestamp: Date.now(),
        source: 'prodify'
      };
      const ssoToken = btoa(JSON.stringify(ssoData));
      
      // Redirecionar com SSO
      const testpathUrl = `http://localhost:3170/v1/auth/prodify?sso_token=${ssoToken}`;
      console.log('🔐 Abrindo TestPath com SSO:', userEmail);
      window.open(testpathUrl, '_blank');
      return;
    }
  } catch (error) {
    console.error('❌ Erro ao preparar TestPath:', error);
  }
}
```

---

## 🔄 FLUXO DE AUTENTICAÇÃO

### **1. Usuário no Prodify:**
1. Usuário está logado no Prodify
2. Clica no ícone "Ecossistema" (Grid 3x3)
3. Popup aparece mostrando todos os apps
4. Clica em "TestPath"

### **2. Prodify Prepara SSO:**
1. Prodify pega email do localStorage
2. Cria token SSO (base64 do JSON)
3. Redireciona para: `http://localhost:3170/v1/auth/prodify?sso_token=TOKEN`

### **3. TestPath Backend Valida:**
1. Endpoint `/v1/auth/prodify` recebe token
2. Decodifica token SSO
3. Verifica se token não expirou (5 minutos)
4. Busca usuário no banco TestPath
5. Se não existir, cria novo usuário
6. Gera JWT de sessão do TestPath
7. Cria cookie `testpath_session`
8. Redireciona para `http://localhost:3000`

### **4. TestPath Frontend:**
1. Recebe redirect com cookie de sessão
2. Valida sessão com backend
3. Carrega dados do usuário
4. Usuário está logado!

---

## 🔐 SEGURANÇA

### **Token SSO:**
- **Validade:** 5 minutos
- **Formato:** Base64(JSON)
- **Dados:** email, timestamp, source
- **Validação:** Timestamp verificado

### **Sessão TestPath:**
- **Tipo:** JWT assinado
- **Validade:** 7 dias
- **Storage:** HTTP-only cookie
- **Renovação:** Automática

### **Comunicação:**
- **Prodify → TestPath:** Token SSO via URL
- **TestPath:** Cookie de sessão
- **CORS:** Whitelisted origins apenas

---

## 🧪 COMO TESTAR

### **1. Garantir que Prodify está rodando:**
```powershell
docker ps | findstr prodify
```

### **2. Garantir que TestPath está rodando:**
```powershell
# Backend
netstat -ano | findstr :3170

# Frontend
netstat -ano | findstr :3000
```

### **3. Testar fluxo:**
1. Abrir Prodify: http://localhost:8001
2. Fazer login no Prodify
3. Clicar em ícone do ecossistema
4. Clicar em "TestPath"
5. Deve abrir TestPath já logado

---

## 🛠️ TROUBLESHOOTING

### **Problema: Token inválido**
**Solução:** Verificar se `PRODIFY_JWT_SECRET` é o mesmo nos dois apps

### **Problema: CORS error**
**Solução:** Adicionar Prodify em `WHITELISTED_ORIGINS`

### **Problema: Usuário não logado no TestPath**
**Solução:** 
1. Verificar console do backend
2. Verificar se cookie foi criado
3. Verificar se redirect funcionou

### **Problema: Banco Prodify não acessível**
**Solução:** 
```powershell
docker exec -it prodify-db-dev psql -U postgres -d super_productive -c "SELECT email FROM \"User\" LIMIT 5;"
```

---

## 📊 BANCOS DE DADOS

### **TestPath (porta 7001):**
- Database: `hoppscotch`
- Tabela: `User`
- Campos: `uid`, `email`, `displayName`, `photoURL`, `isAdmin`

### **Prodify (porta 8010):**
- Database: `super_productive`
- Tabela: `User`
- Campos: `id`, `email`, `name`, `image`

---

## 🎨 ÍCONE DO ECOSSISTEMA

### **Localização:**
- Header do TestPath (ao lado do logo)
- Ícone: Grid 3x3 (Lucide Icons)
- Cor: Accent (roxo/azul)

### **Funcionalidade:**
- Clique abre popup
- Lista todos os apps do ecossistema:
  - Prodify
  - OnScope
  - JazzUp
  - DeepQuest
  - OpenUIX

### **SSO:**
- Apps que requerem SSO: OnScope, JazzUp, OpenUIX
- Apps sem SSO: Prodify, DeepQuest

---

## 🔄 SINCRONIZAÇÃO BIDIRECIONAL

### **Prodify → TestPath:**
- Usuário clica no TestPath no Prodify
- SSO automático
- Sessão criada no TestPath

### **TestPath → Prodify:**
- Botão "Ecossistema" no TestPath
- Lista inclui Prodify
- Redirect de volta ao Prodify se necessário

---

## 📝 PRÓXIMOS PASSOS

### **Para finalizar integração:**

1. **Atualizar `.env` do TestPath:**
   - Adicionar configurações do Prodify
   - Adicionar URLs do ecossistema

2. **Atualizar Prodify:**
   - Modificar `EcosystemPopup.tsx`
   - Adicionar lógica de SSO para TestPath

3. **Adicionar traduções:**
   - `locales/en.json`
   - Adicionar bloco "ecosystem"

4. **Testar fluxo completo:**
   - Prodify → TestPath
   - TestPath → Prodify
   - Validar sessão

---

## ⚠️ VARIÁVEIS DE AMBIENTE CRÍTICAS

**DEVEM estar configuradas:**
```ini
PRODIFY_JWT_SECRET=your-secret-key           # Mesmo do Prodify!
DATABASE_URL=postgresql://...                # Banco TestPath
PRODIFY_DB_URL=postgresql://...              # Banco Prodify (opcional)
WHITELISTED_ORIGINS=...,http://localhost:8001  # Incluir Prodify
```

---

**Criado:** 23/10/2025  
**Status:** ⏳ Implementado - Aguardando configuração do `.env`

