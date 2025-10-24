# 🎨 REBRAND TESTPATH - Guia de Implementação

## 📍 LOGO TESTPATH

**Logo Principal:** `TestPath/Imagen/Gemini_Generated_Image_k4c1yyk4c1yyk4c1.png`

**Logos Alternativos:**
- `TestPath/Imagen/Gemini_Generated_Image_67xz7867xz7867xz.png`
- `TestPath/Imagen/Gemini_Generated_Image_j0orhlj0orhlj0or.png`
- `TestPath/Imagen/Gemini_Generated_Image_rmmlzzrmmlzzrmml.png`

---

## 🔧 IMPLEMENTAÇÃO DO REBRAND

### **PASSO 1: Preparar Logo em Diferentes Tamanhos**

Você precisa converter o logo para os seguintes tamanhos:

```
16x16    - favicon.ico
32x32    - favicon pequeno
128x128  - ícone médio
192x192  - PWA Android
256x256  - PWA
512x512  - PWA alta resolução
1024x1024 - PWA máxima resolução
```

**Ferramentas online (gratuitas):**
- https://www.favicon-generator.org/
- https://realfavicongenerator.net/
- https://www.img2go.com/convert-to-ico

**Ou usar ImageMagick (se instalado):**
```powershell
# Instalar ImageMagick
# winget install ImageMagick.ImageMagick

# Converter
magick "Imagen\Gemini_Generated_Image_k4c1yyk4c1yyk4c1.png" -resize 192x192 "testpath-192.png"
magick "Imagen\Gemini_Generated_Image_k4c1yyk4c1yyk4c1.png" -resize 512x512 "testpath-512.png"
# ... etc
```

---

### **PASSO 2: Substituir Arquivos**

Copie os logos gerados para os seguintes locais:

```powershell
# Navegue até a raiz do TestPath
cd C:\App\Deployer\Project_Affinify\TestPath

# Favicon
Copy-Item "testpath-32.ico" "packages\hoppscotch-selfhost-web\public\favicon.ico"

# Ícone principal
Copy-Item "testpath-512.png" "packages\hoppscotch-selfhost-web\public\icon.png"

# Apple touch icon
Copy-Item "testpath-180.png" "packages\hoppscotch-selfhost-web\public\apple-touch-icon.png"

# PWA icons
Copy-Item "testpath-16.png" "packages\hoppscotch-common\public\icons\pwa-16x16.png"
Copy-Item "testpath-32.png" "packages\hoppscotch-common\public\icons\pwa-32x32.png"
Copy-Item "testpath-128.png" "packages\hoppscotch-common\public\icons\pwa-128x128.png"
Copy-Item "testpath-192.png" "packages\hoppscotch-common\public\icons\pwa-192x192.png"
Copy-Item "testpath-256.png" "packages\hoppscotch-common\public\icons\pwa-256x256.png"
Copy-Item "testpath-512.png" "packages\hoppscotch-common\public\icons\pwa-512x512.png"
Copy-Item "testpath-1024.png" "packages\hoppscotch-common\public\icons\pwa-1024x1024.png"
```

---

### **PASSO 3: Atualizar Código**

#### **3.1 index.html**

**Arquivo:** `packages/hoppscotch-selfhost-web/index.html`

Alterar:
```html
<title>Hoppscotch • Open source API development ecosystem</title>
```

Para:
```html
<title>TestPath • Professional API Development Platform</title>
```

---

#### **3.2 meta.ts**

**Arquivo:** `packages/hoppscotch-selfhost-web/meta.ts`

Procurar e substituir:
- `Hoppscotch` → `TestPath`
- `Open source API development ecosystem` → `Professional API Development Platform`
- URLs do Hoppscotch → URLs do TestPath

---

#### **3.3 package.json**

**Arquivo:** `packages/hoppscotch-selfhost-web/package.json`

Alterar:
```json
{
  "name": "@hoppscotch/selfhost-web",
  "description": "Self-hosted web client for Hoppscotch",
  // ...
}
```

Para:
```json
{
  "name": "@testpath/web",
  "description": "TestPath Professional API Development Platform",
  // ...
}
```

---

### **PASSO 4: Atualizar Manifest PWA**

**Arquivo:** `packages/hoppscotch-selfhost-web/vite.config.ts`

Procurar `VitePWA` e atualizar:

```typescript
VitePWA({
  manifest: {
    name: "TestPath",
    short_name: "TestPath",
    description: "Professional API Development Platform",
    start_url: "/?source=pwa",
    background_color: "#000000", // Cor de fundo da sua marca
    theme_color: "#6366f1", // Cor do tema da sua marca
    icons: [
      {
        src: "/icons/pwa-192x192.png",
        sizes: "192x192",
        type: "image/png",
      },
      {
        src: "/icons/pwa-512x512.png",
        sizes: "512x512",
        type: "image/png",
      },
    ],
  },
}),
```

---

### **PASSO 5: Adicionar Créditos (Obrigatório MIT)**

#### **5.1 Criar Arquivo de Licenças**

**Arquivo:** `TestPath/THIRD_PARTY_LICENSES.md`

```markdown
# Licenças de Terceiros

## Hoppscotch

Este software é baseado em Hoppscotch.

**Copyright:** (c) 2022 Hoppscotch  
**Licença:** MIT License  
**Repositório:** https://github.com/hoppscotch/hoppscotch  

### MIT License (Hoppscotch)

```
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
```

## Outras Dependências

[Liste aqui outras dependências principais e suas licenças]
```

---

#### **5.2 Adicionar Footer na Interface**

**Arquivo:** `packages/hoppscotch-common/src/layouts/default.vue` (ou similar)

Adicionar no footer:
```html
<footer class="footer">
  <div class="footer-content">
    <span>© 2025 TestPath</span>
    <span class="separator">•</span>
    <span>Based on <a href="https://github.com/hoppscotch/hoppscotch" target="_blank">Hoppscotch</a> (MIT License)</span>
  </div>
</footer>
```

---

## 🚀 SCRIPT DE REBRAND AUTOMÁTICO

Crie um script para facilitar o rebrand:

**Arquivo:** `TestPath/rebrand.ps1`

```powershell
# Rebrand automático TestPath
Write-Host "🎨 Iniciando rebrand para TestPath..." -ForegroundColor Cyan

# 1. Copiar logos
Write-Host "📦 Copiando logos..." -ForegroundColor Yellow
$logoSource = "Imagen\Gemini_Generated_Image_k4c1yyk4c1yyk4c1.png"

# Você precisa ter os logos em diferentes tamanhos primeiro!
# Este é apenas um exemplo

# 2. Substituir textos
Write-Host "✏️  Substituindo textos..." -ForegroundColor Yellow

# Atualizar index.html
$indexPath = "packages\hoppscotch-selfhost-web\index.html"
(Get-Content $indexPath) -replace 'Hoppscotch • Open source API development ecosystem', 'TestPath • Professional API Development Platform' | Set-Content $indexPath

# 3. Criar arquivo de licenças
Write-Host "📄 Criando arquivo de licenças..." -ForegroundColor Yellow
# (código para criar THIRD_PARTY_LICENSES.md)

Write-Host "✅ Rebrand concluído!" -ForegroundColor Green
Write-Host "⚠️  ATENÇÃO: Verifique manualmente todos os arquivos!" -ForegroundColor Yellow
```

---

## ⚠️ IMPORTANTE - NÃO ESQUEÇA

### **Obrigatório pela MIT License:**
1. ✅ Manter arquivo LICENSE original
2. ✅ Adicionar créditos ao Hoppscotch
3. ✅ Criar THIRD_PARTY_LICENSES.md
4. ✅ Mencionar "Based on Hoppscotch" na interface

### **Recomendado:**
1. ✅ Link para repositório original
2. ✅ Agradecer aos contribuidores
3. ✅ Manter espírito open source

### **Proibido:**
1. ❌ Remover licença MIT original
2. ❌ Fingir ser criador original
3. ❌ Usar marca "Hoppscotch" como sua

---

## 🎯 ORDEM DE IMPLEMENTAÇÃO

1. **DIA 1-2:** Preparar logos em todos os tamanhos
2. **DIA 3:** Substituir arquivos de logo
3. **DIA 4:** Atualizar textos na interface
4. **DIA 5:** Criar THIRD_PARTY_LICENSES.md
5. **DIA 6:** Adicionar footer com créditos
6. **DIA 7:** Testar tudo localmente
7. **DIA 8-14:** Deploy em produção

---

## 📝 CHECKLIST DE REBRAND

### **Assets Visuais:**
- [ ] Logo 16x16 (favicon)
- [ ] Logo 32x32 (favicon)
- [ ] Logo 128x128
- [ ] Logo 192x192 (PWA)
- [ ] Logo 256x256
- [ ] Logo 512x512
- [ ] Logo 1024x1024
- [ ] Apple touch icon 180x180

### **Arquivos HTML:**
- [ ] index.html (título)
- [ ] meta tags (description, og:tags)
- [ ] manifest.json (PWA)

### **Arquivos de Código:**
- [ ] package.json (nome, descrição)
- [ ] meta.ts (APP_INFO)
- [ ] vite.config.ts (PWA manifest)
- [ ] Layout principal (footer)

### **Documentação:**
- [ ] README.md
- [ ] THIRD_PARTY_LICENSES.md
- [ ] About page

### **Legal:**
- [ ] Créditos adicionados
- [ ] MIT License mantida
- [ ] Copyright atualizado

---

**Criado:** 23/10/2025  
**Para:** Implementação do rebrand TestPath  
**Status:** 📋 Aguardando execução  
**Tempo Estimado:** 7-14 dias

