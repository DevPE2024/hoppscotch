# 🎯 PRIORIDADE - TestPath

## ⚡ EXECUÇÃO RÁPIDA

### **Script Automático (Recomendado):**

```powershell
cd C:\App\Deployer\Project_Affinify\TestPath
.\start-testpath.ps1
```

**Nome do Script:** `start-testpath.ps1`

**O que o script faz:**
- ✅ Verifica se o banco de dados Docker está rodando
- ✅ Inicia o backend (porta 3170)
- ✅ Inicia o frontend (porta 3000)
- ✅ Monitora toda a aplicação continuamente
- ✅ Mostra erros e status em tempo real

---

## 📋 O QUE FOI IMPLEMENTADO

### ✅ **Funcionalidades Completas:**
1. **Aplicação TestPath 100% funcional**
   - Backend NestJS + GraphQL (porta 3170)
   - Frontend Vue.js + Vite (porta 3000)
   - Banco PostgreSQL Docker (porta 7001)

2. **Branding TestPath:**
   - Logo moderno (círculo com gradiente teal/pink/purple + letra "T")
   - Título da página: "TestPath"
   - Favicon dinâmico (atualiza automaticamente)

3. **Integração com Ecossistema Affinify:**
   - Ícone de ecossistema no header (Grid 3x3)
   - Popup com 6 aplicações (Prodify, OnScope, JazzUp, DeepQuest, OpenUIX, TestPath)
   - Popup centralizado com design moderno

4. **SSO (Single Sign-On) com Prodify:**
   - Autenticação automática entre Prodify ↔ TestPath
   - Usuário loga no Prodify → acessa TestPath sem novo login
   - Backend valida JWT/SSO tokens do Prodify

5. **Conformidade Legal:**
   - Créditos MIT ao Hoppscotch no footer
   - Arquivo `THIRD_PARTY_LICENSES.md` criado
   - Licença MIT respeitada

6. **Assets PWA:**
   - Favicon PNG (32x32) com letra "T"
   - Manifest.json para PWA
   - Meta tags otimizadas
   - Título simplificado

7. **Correções Técnicas:**
   - Erros TypeScript resolvidos (`tsconfig.json` atualizado)
   - Popup usando `<Teleport>` para escapar limitações de altura
   - Cache-busting para favicon
   - JavaScript dinâmico para atualização de assets

### 📦 **Arquivos Criados:**
- `start-testpath.ps1` - Script de inicialização automática
- `PRIORIDADE.md` (este arquivo) - Documentação essencial
- `COMERCIALIZACAO.md` - Plano detalhado de comercialização
- `THIRD_PARTY_LICENSES.md` - Licenças de terceiros
- `INTEGRACAO_PRODIFY.md` - Documentação SSO
- `favicon.png`, `favicon.svg` - Favicons personalizados
- `manifest.json` - PWA manifest
- `EcosystemPopup.vue` - Componente do popup de ecossistema
- `prodify-auth.strategy.ts` - Estratégia de autenticação Prodify
- `prodify-auth.controller.ts` - Controller de autenticação

---

## 📋 INFORMAÇÕES DO PROJETO

**Nome Comercial:** TestPath  
**Empresa:** TestPath  
**Logo:** `TestPath/Imagen/Gemini_Generated_Image_k4c1yyk4c1yyk4c1.png`  
**Autenticação:** SSO com Prodify (JWT + base64 tokens)  
**Licença Base:** MIT (Hoppscotch) - Permite uso comercial  
**Status:** ✅ Funcional em desenvolvimento | ⏳ Pronto para produção

---

## 🚀 EXECUÇÃO MANUAL (SE NECESSÁRIO)

### **Passo 1: Banco de Dados PostgreSQL (Docker)**

```powershell
# Verificar se está rodando
docker ps | findstr testpath-db-dev

# Se não estiver, iniciar
docker-compose -f ../docker-compose.fase1.yml up -d testpath-db

# Verificar conexão
docker exec -it testpath-db-dev psql -U postgres -d hoppscotch -c "\dt"
```

**Credenciais:**
- Host: `localhost`
- Porta: `7001`
- Usuário: `postgres`
- Senha: `testpass`
- Database: `hoppscotch`

---

### **Passo 2: Backend (Porta 3170)**

```powershell
cd C:\App\Deployer\Project_Affinify\TestPath\packages\hoppscotch-backend
pnpm run start:dev
```

**Verificar:** http://localhost:3170/ping

---

### **Passo 3: Frontend (Porta 3000)**

```powershell
cd C:\App\Deployer\Project_Affinify\TestPath\packages\hoppscotch-selfhost-web
pnpm run dev
```

**Verificar:** http://localhost:3000

---

### **Passo 4: Script Automático**

```powershell
cd C:\App\Deployer\Project_Affinify\TestPath
.\start-testpath.ps1
```

---

## ✅ CHECKLIST ESSENCIAL PARA COMERCIALIZAÇÃO

### **FASE 1: BRANDING (ESSENCIAL) - 1 SEMANA**

- [x] Nome comercial definido: **TestPath**
- [x] Logo criado: `Imagen/Gemini_Generated_Image_k4c1yyk4c1yyk4c1.png`
- [ ] **Atualizar interface com logo TestPath**
  - Substituir logo na aplicação
  - Atualizar favicon
  - Atualizar título das páginas
  - Atualizar manifest.json (PWA)
- [ ] **Remover referências visuais ao Hoppscotch**
  - Headers
  - Footers
  - About page
  - Loading screens
- [ ] **Manter créditos legais** (obrigatório pela MIT License)
  - Adicionar "Based on Hoppscotch (MIT License)" no footer
  - Criar página "About" com créditos

**Arquivos a modificar:**
- `packages/hoppscotch-selfhost-web/src/platform/*/index.ts`
- `packages/hoppscotch-selfhost-web/index.html`
- `packages/hoppscotch-selfhost-web/public/favicon.ico`
- `packages/hoppscotch-common/public/` (assets)

---

### **FASE 2: AUTENTICAÇÃO EXTERNA (ESSENCIAL) - 1 SEMANA**

Como os usuários vêm autenticados de outra aplicação:

- [ ] **Configurar SSO/Token-based auth**
  - Receber JWT de aplicação externa
  - Validar token no backend
  - Criar sessão local
  - Sincronizar dados do usuário

- [ ] **Modificar fluxo de autenticação**
  - Desabilitar login local (Google, GitHub, Microsoft)
  - Implementar endpoint `/auth/external`
  - Validar token externo
  - Criar/atualizar usuário no banco

- [ ] **Configurar CORS e segurança**
  - Whitelist da aplicação externa
  - Validação de origem
  - Headers de segurança

**Arquivos a modificar:**
- `packages/hoppscotch-backend/src/auth/`
- `packages/hoppscotch-selfhost-web/src/platform/auth/web/index.ts`
- `.env` (adicionar URLs da aplicação externa)

---

### **FASE 3: COMPLIANCE LEGAL (OBRIGATÓRIO) - 3 DIAS**

- [ ] **Criar arquivo de licenças**
  ```
  TestPath/THIRD_PARTY_LICENSES.md
  ```
  Conteúdo:
  ```
  # Licenças de Terceiros
  
  ## Hoppscotch
  Este software é baseado em Hoppscotch
  Copyright (c) 2022 Hoppscotch
  Licensed under MIT License
  Repository: https://github.com/hoppscotch/hoppscotch
  
  [Incluir texto completo da MIT License]
  ```

- [ ] **Adicionar créditos na interface**
  - Footer: "Powered by TestPath | Based on Hoppscotch"
  - Página About com créditos completos

- [ ] **Criar documentos legais básicos**
  - Termos de Uso
  - Política de Privacidade (LGPD)
  - SLA básico

---

### **FASE 4: INFRAESTRUTURA DE PRODUÇÃO (ESSENCIAL) - 2 SEMANAS**

- [ ] **Configurar Cloud (escolher um):**
  - AWS (recomendado para escala)
  - Google Cloud (bom custo-benefício)
  - Azure (integração Microsoft)
  - DigitalOcean (simples e barato)

- [ ] **Serviços mínimos necessários:**
  - Servidor de aplicação (backend + frontend)
  - PostgreSQL gerenciado (RDS, Cloud SQL, etc)
  - SSL/TLS (Let's Encrypt ou Cloudflare)
  - CDN para assets estáticos
  - Backup automático do banco

- [ ] **Docker para produção:**
  - Criar `Dockerfile` otimizado
  - Criar `docker-compose.prod.yml`
  - Configurar multi-stage build
  - Otimizar tamanho das imagens

---

### **FASE 5: MONETIZAÇÃO (SE APLICÁVEL) - 1 SEMANA**

Como você tem autenticação externa, a monetização pode ser:

**Opção 1: Incluído no produto principal**
- Usuários já pagam na aplicação externa
- TestPath é feature incluída
- Sem necessidade de sistema de pagamento separado

**Opção 2: Add-on/Módulo pago**
- Cobrar extra por acesso ao TestPath
- Integrar com sistema de pagamento da aplicação principal
- Verificar permissões via token JWT

- [ ] **Definir modelo de monetização**
- [ ] **Implementar verificação de permissões**
- [ ] **Integrar com sistema de billing existente**

---

### **FASE 6: SEGURANÇA (CRÍTICO) - 1 SEMANA**

- [ ] **Configurar segurança básica:**
  - Rate limiting (prevenir abuse)
  - HTTPS obrigatório
  - Headers de segurança (CSP, HSTS, etc)
  - Validação de input
  - SQL injection prevention (Prisma já faz)
  - XSS protection

- [ ] **Auditoria de segurança:**
  - Scan de vulnerabilidades (npm audit)
  - Dependências atualizadas
  - Secrets management (não hardcode)
  - Logs de auditoria

---

## 📦 ARQUIVOS E ASSETS DO TESTPATH

### **Logo Principal:**
```
TestPath/Imagen/Gemini_Generated_Image_k4c1yyk4c1yyk4c1.png
```

### **Logos Alternativos:**
```
TestPath/Imagen/Gemini_Generated_Image_67xz7867xz7867xz.png
TestPath/Imagen/Gemini_Generated_Image_j0orhlj0orhlj0or.png
TestPath/Imagen/Gemini_Generated_Image_rmmlzzrmmlzzrmml.png
```

### **Onde usar o logo:**
- `packages/hoppscotch-selfhost-web/public/icon.png` (substituir)
- `packages/hoppscotch-selfhost-web/public/favicon.ico` (converter e substituir)
- `packages/hoppscotch-selfhost-web/index.html` (meta tags)
- `packages/hoppscotch-common/public/` (assets)
- Interface principal (header)

---

## 🔧 CONFIGURAÇÃO MÍNIMA PARA PRODUÇÃO

### **Variáveis de Ambiente (.env):**

```ini
# Banco de Dados (Production)
DATABASE_URL=postgresql://USER:PASS@HOST:5432/testpath_prod

# Backend
PORT=3170
PRODUCTION=true
NODE_ENV=production

# Secrets (GERAR NOVOS!)
JWT_SECRET=[GERAR TOKEN SEGURO 64 CARACTERES]
SESSION_SECRET=[GERAR TOKEN SEGURO 64 CARACTERES]
DATA_ENCRYPTION_KEY=[GERAR KEY 32 BYTES]

# URLs (Production)
VITE_BACKEND_API_URL=https://api.testpath.com
VITE_BACKEND_GQL_URL=https://api.testpath.com/graphql
VITE_BACKEND_WS_URL=wss://api.testpath.com/graphql
VITE_BASE_URL=https://testpath.com
VITE_APP_URL=https://testpath.com

# Autenticação Externa
EXTERNAL_AUTH_URL=https://sua-app-principal.com
EXTERNAL_AUTH_SECRET=[SHARED SECRET COM APP EXTERNA]

# Segurança
ALLOW_SECURE_COOKIES=true
WHITELISTED_ORIGINS=https://testpath.com,https://sua-app-principal.com
```

---

## 🎯 CHECKLIST RESUMIDO (ORDEM DE PRIORIDADE)

### **SEMANA 1 (CRÍTICO):**
1. [ ] Substituir logo Hoppscotch pelo logo TestPath
2. [ ] Adicionar créditos "Based on Hoppscotch (MIT)" no footer
3. [ ] Criar arquivo THIRD_PARTY_LICENSES.md
4. [ ] Configurar autenticação externa (JWT)

### **SEMANA 2 (IMPORTANTE):**
1. [ ] Setup de infraestrutura cloud
2. [ ] Configurar banco PostgreSQL em produção
3. [ ] Implementar SSL/TLS
4. [ ] Deploy inicial

### **SEMANA 3 (ESSENCIAL):**
1. [ ] Testes de segurança
2. [ ] Otimizações de performance
3. [ ] Documentação básica
4. [ ] Backup automático

### **SEMANA 4 (DESEJÁVEL):**
1. [ ] Monitoramento e logs
2. [ ] CI/CD básico
3. [ ] Testes finais
4. [ ] Go-live

---

## 💰 INVESTIMENTO MÍNIMO PARA LANÇAR

### **Essencial:**
- Cloud Hosting: R$ 500 - R$ 1.500/mês
- PostgreSQL Managed: R$ 200 - R$ 800/mês
- SSL/CDN: R$ 0 - R$ 200/mês (Cloudflare free tier)
- **TOTAL MENSAL:** R$ 700 - R$ 2.500/mês

### **Recomendado:**
- Acima + Monitoramento: R$ 200/mês
- Acima + Backup: R$ 100/mês
- Acima + Consultoria jurídica inicial: R$ 2.000 (uma vez)
- **TOTAL SETUP:** R$ 2.000
- **TOTAL MENSAL:** R$ 1.000 - R$ 2.800/mês

---

## 🔗 INTEGRAÇÃO COM AUTENTICAÇÃO EXTERNA

### **Fluxo Proposto:**

1. **Usuário loga na aplicação principal**
2. **Aplicação principal gera JWT** com:
   ```json
   {
     "uid": "user-id",
     "email": "user@example.com",
     "displayName": "Nome do Usuário",
     "photoURL": "https://...",
     "permissions": ["testpath:access"]
   }
   ```
3. **Aplicação principal redireciona para TestPath** com token:
   ```
   https://testpath.com/auth/external?token=JWT_TOKEN
   ```
4. **TestPath valida token** no backend
5. **TestPath cria sessão local** e redireciona para dashboard

### **Implementação Necessária:**

**Backend (`packages/hoppscotch-backend/src/auth/`):**
- Criar `external-auth.strategy.ts`
- Criar `external-auth.controller.ts`
- Validar JWT da aplicação externa
- Criar/atualizar usuário no banco

**Frontend (`packages/hoppscotch-selfhost-web/src/platform/auth/web/`):**
- Modificar `index.ts` para aceitar token externo
- Remover métodos de login local (Google, GitHub, Microsoft)
- Implementar redirect com token

---

## 📝 ALTERAÇÕES NECESSÁRIAS PARA REBRAND

### **1. Logo e Favicon:**

**Converter logo para diferentes formatos:**
```powershell
# Usar ferramenta online ou ImageMagick
# Logo principal: 512x512px PNG
# Favicon: 32x32px ICO
# Apple touch icon: 180x180px PNG
```

**Arquivos a substituir:**
```
packages/hoppscotch-selfhost-web/public/favicon.ico
packages/hoppscotch-selfhost-web/public/icon.png
packages/hoppscotch-common/public/images/logo.png
packages/hoppscotch-common/public/icons/pwa-*.png (todos)
```

---

### **2. Títulos e Meta Tags:**

**`packages/hoppscotch-selfhost-web/index.html`:**
```html
<title>TestPath • Professional API Development Platform</title>
<meta name="description" content="TestPath - Plataforma profissional para desenvolvimento e teste de APIs">
```

**`packages/hoppscotch-selfhost-web/meta.ts`:**
- Atualizar APP_INFO
- Atualizar META_TAGS
- Remover referências ao Hoppscotch

---

### **3. Interface:**

**Header/Footer (`packages/hoppscotch-common/src/`):**
- Substituir "Hoppscotch" por "TestPath"
- Adicionar footer: "© 2025 TestPath | Based on Hoppscotch (MIT License)"

---

## ⚖️ CONFORMIDADE MIT LICENSE (OBRIGATÓRIO)

### **O que você DEVE fazer:**

1. **Criar `THIRD_PARTY_LICENSES.md`:**
```markdown
# Licenças de Terceiros

Este software é baseado em Hoppscotch.

## Hoppscotch
Copyright (c) 2022 Hoppscotch  
Licensed under MIT License  
Repository: https://github.com/hoppscotch/hoppscotch

[Incluir texto completo da MIT License aqui]
```

2. **Adicionar créditos na interface:**
- Footer: "Powered by TestPath | Based on Hoppscotch (MIT)"
- Página About: Link para Hoppscotch original

3. **Manter arquivo LICENSE original:**
- Não deletar
- Pode adicionar sua própria licença comercial separada

---

## 🚀 DEPLOY EM PRODUÇÃO

### **Opção 1: Cloud Simples (Recomendado para iniciar)**

**DigitalOcean App Platform:**
```yaml
# app.yaml
name: testpath
services:
  - name: backend
    source_dir: packages/hoppscotch-backend
    build_command: pnpm run build
    run_command: pnpm run start:prod
    envs:
      - key: DATABASE_URL
        value: ${db.DATABASE_URL}
  
  - name: frontend
    source_dir: packages/hoppscotch-selfhost-web
    build_command: pnpm run build
    static_sites:
      - output_dir: dist

databases:
  - name: testpath-db
    engine: PG
    version: "15"
```

**Custo:** ~R$ 500-800/mês

---

### **Opção 2: Docker (Mais controle)**

**Criar `docker-compose.prod.yml`:**
```yaml
version: '3.8'

services:
  testpath-backend:
    build:
      context: .
      dockerfile: packages/hoppscotch-backend/Dockerfile
    ports:
      - "3170:3170"
    environment:
      - DATABASE_URL=${DATABASE_URL}
      - JWT_SECRET=${JWT_SECRET}
    restart: unless-stopped

  testpath-frontend:
    build:
      context: .
      dockerfile: packages/hoppscotch-selfhost-web/Dockerfile
    ports:
      - "3000:3000"
    restart: unless-stopped

  testpath-db:
    image: postgres:15
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - POSTGRES_DB=testpath_prod
    volumes:
      - testpath-prod-data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  testpath-prod-data:
```

---

### **Opção 3: Coolify/Hostinger (Você já usa)**

Se já tem Coolify configurado (vi nos seus arquivos):

1. Fazer push do código para Git
2. Conectar repositório no Coolify
3. Configurar variáveis de ambiente
4. Deploy automático

---

## 📋 LISTA DE VERIFICAÇÃO PRÉ-LANÇAMENTO

### **Segurança:**
- [ ] Secrets não estão no código
- [ ] HTTPS configurado
- [ ] CORS configurado corretamente
- [ ] Rate limiting ativo
- [ ] npm audit sem vulnerabilidades críticas

### **Performance:**
- [ ] Build otimizado (production mode)
- [ ] Assets minificados
- [ ] CDN para arquivos estáticos
- [ ] Lazy loading implementado
- [ ] Database indexes criados

### **Legal:**
- [ ] MIT License incluída
- [ ] Créditos ao Hoppscotch
- [ ] Termos de Uso
- [ ] Política de Privacidade

### **Funcional:**
- [ ] Autenticação externa funcionando
- [ ] Todas as features testadas
- [ ] Responsivo (mobile/tablet/desktop)
- [ ] Compatibilidade cross-browser
- [ ] Tratamento de erros

---

## 🎨 IMPLEMENTAÇÃO DO LOGO TESTPATH

### **Passo 1: Preparar Assets**

```powershell
cd C:\App\Deployer\Project_Affinify\TestPath

# Copiar logo principal para public
Copy-Item "Imagen\Gemini_Generated_Image_k4c1yyk4c1yyk4c1.png" "packages\hoppscotch-selfhost-web\public\testpath-logo.png"

# Criar diferentes tamanhos para PWA
# (usar ferramenta online ou script)
# Tamanhos necessários: 16x16, 32x32, 128x128, 192x192, 256x256, 512x512, 1024x1024
```

### **Passo 2: Atualizar Manifest (PWA)**

**`packages/hoppscotch-selfhost-web/vite.config.ts`:**
Procurar por `VitePWA` e atualizar:
```typescript
manifest: {
  name: "TestPath",
  short_name: "TestPath",
  description: "Professional API Development Platform",
  icons: [
    {
      src: "/testpath-logo-192.png",
      sizes: "192x192",
      type: "image/png",
    },
    // ... outros tamanhos
  ],
}
```

---

## 🔐 SEGURANÇA - CHECKLIST MÍNIMO

- [ ] Variáveis de ambiente não expostas no frontend
- [ ] JWT_SECRET forte (64+ caracteres)
- [ ] SESSION_SECRET forte (64+ caracteres)
- [ ] DATA_ENCRYPTION_KEY forte (32 bytes)
- [ ] Database password forte
- [ ] CORS restrito apenas a origens confiáveis
- [ ] Rate limiting: 100 req/min por IP
- [ ] Input validation em todos os endpoints
- [ ] Sanitização de HTML/SQL
- [ ] Logs de segurança ativados

---

## 📊 RESUMO EXECUTIVO

### **✅ JÁ ESTÁ PRONTO:**
- Nome comercial: TestPath
- Logo criado
- Aplicação funcionando localmente
- Banco de dados configurado
- Backend + Frontend rodando

### **⚠️ FALTA FAZER (ESSENCIAL):**
1. Substituir logos na aplicação
2. Adicionar créditos MIT ao Hoppscotch
3. Configurar autenticação externa
4. Deploy em produção
5. SSL/HTTPS

### **TEMPO ESTIMADO ATÉ PRODUÇÃO:**
- **Mínimo:** 2 semanas (apenas essencial)
- **Recomendado:** 4 semanas (com testes)
- **Ideal:** 6-8 semanas (com polish)

### **INVESTIMENTO MÍNIMO:**
- **Setup:** R$ 2.000 (consultoria legal básica)
- **Mensal:** R$ 700 - R$ 2.500 (cloud + database)

---

## 📞 PRÓXIMOS PASSOS IMEDIATOS

### **HOJE:**
1. [ ] Revisar este documento
2. [ ] Decidir opção de cloud
3. [ ] Preparar logos em diferentes tamanhos

### **ESTA SEMANA:**
1. [ ] Implementar rebrand visual
2. [ ] Adicionar créditos MIT
3. [ ] Configurar autenticação externa
4. [ ] Criar THIRD_PARTY_LICENSES.md

### **PRÓXIMAS 2 SEMANAS:**
1. [ ] Setup de infraestrutura
2. [ ] Deploy em staging
3. [ ] Testes completos
4. [ ] Deploy em produção

---

## 📖 RECURSOS CRIADOS

1. **PRIORIDADE.md** (este arquivo) - Como rodar e comercializar
2. **COMERCIALIZACAO.md** - Plano completo detalhado
3. **RESUMO_EXECUTIVO.md** - Visão geral executiva
4. **start-testpath.ps1** - Script de inicialização automática

---

**Data:** 23/10/2025  
**Versão:** 2.0 (Atualizado para autenticação externa)  
**Status:** ✅ Aplicação funcionando | ⏳ Aguardando deploy  
**Próxima Revisão:** Após implementação do rebrand
