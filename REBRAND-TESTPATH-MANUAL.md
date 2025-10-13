# Guia de Rebrand Manual - Hoppscotch para TestPath

## ✅ O QUE VOCÊ PRECISA FAZER

Baseado na análise do seu projeto e nas imagens fornecidas, aqui está o guia completo e seguro para fazer o rebrand.

---

## 📋 RESUMO EXECUTIVO

**SIM, você pode comercializar com essas modificações!**

A licença MIT permite:
- ✅ Alterar nome para TestPath
- ✅ Substituir logos
- ✅ Remover autenticação (se não precisar)
- ✅ Vender o produto

**MAS você DEVE:**
- ⚠️ Manter créditos originais (arquivo THIRD-PARTY-LICENSES.md)
- ⚠️ Incluir licença MIT
- ⚠️ Consultar advogado antes de comercializar

---

## 🎨 ETAPA 1: Substituir Logos (MANUAL)

### Locais onde copiar as imagens:

```powershell
# Logo principal (transparente)
Copy-Item "Imagen/Gemini_Generated_Image_j0orhlj0orhlj0or.png" -Destination "packages/hoppscotch-common/public/logo.png" -Force

# Ícone/Favicon  
Copy-Item "Imagen/Gemini_Generated_Image_rmmlzzrmmlzzrmml.png" -Destination "packages/hoppscotch-common/public/icon.png" -Force
```

### Diretórios importantes:
- `packages/hoppscotch-common/public/`
- `packages/hoppscotch-selfhost-web/dist/` (após build)
- `packages/hoppscotch-sh-admin/public/`

**Observação**: Se algum diretório não existir, não se preocupe. Os principais são criados durante o build.

---

## 📝 ETAPA 2: Buscar e Substituir Textos

### Opção A: Usando VS Code (Recomendado)

1. Abra o VS Code na raiz do projeto
2. Pressione `Ctrl + Shift + H` (Find & Replace)
3. Substitua um de cada vez:

```
"Hoppscotch" → "TestPath"
"hoppscotch" → "testpath"
"HOPPSCOTCH" → "TESTPATH"
```

4. **IMPORTANTE**: Exclua destas pastas:
   - `node_modules`
   - `.git`
   - `dist`
   - `build`

### Opção B: Script PowerShell Simples

Crie um arquivo `substituir-textos.ps1`:

```powershell
# Substituir Hoppscotch por TestPath
Get-ChildItem -Recurse -Include *.json,*.ts,*.vue,*.html,*.js,*.md | 
Where-Object { $_.FullName -notmatch "node_modules|\.git|dist" } |
ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $content = $content -replace "Hoppscotch", "TestPath"
    $content = $content -replace "hoppscotch", "testpath"
    Set-Content $_.FullName $content -NoNewline
}
```

Execute: `.\substituir-textos.ps1`

---

## 📄 ETAPA 3: Criar Conformidade Legal

Crie o arquivo `THIRD-PARTY-LICENSES.md` na raiz:

```markdown
# Third Party Licenses

## Hoppscotch

This project is based on Hoppscotch (https://github.com/hoppscotch/hoppscotch)

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

---

We are grateful to the Hoppscotch team for their excellent open-source work.
```

---

## 🔧 ETAPA 4: Sobre a Autenticação

Você mencionou que não precisa de autenticação porque virá de outro sistema.

### Opção 1: Manter mas Não Usar (Recomendado)
- Deixe o código de autenticação
- Simplesmente não exiba os botões de login na UI
- Mais fácil e seguro

### Opção 2: Remover Completamente (Avançado)
Isso requer modificações profundas no código. Arquivos a modificar:

```
packages/hoppscotch-backend/src/auth/
packages/hoppscotch-common/src/components/auth/
packages/hoppscotch-common/src/stores/auth/
```

**Recomendação**: Deixe o código, apenas esconda a UI de login.

---

## 🐳 ETAPA 5: Rebuild Docker

Após fazer as modificações:

```powershell
# Parar containers
docker compose --profile dev down

# Limpar cache (opcional mas recomendado)
docker system prune -f

# Rebuild e iniciar
docker compose --profile dev up -d --build
```

**Tempo estimado**: 10-15 minutos (primeira vez)

---

## ✅ CHECKLIST FINAL

Antes de considerar concluído:

- [ ] Logos substituídos em `packages/*/public/`
- [ ] Textos "Hoppscotch" → "TestPath" substituídos
- [ ] Arquivo `THIRD-PARTY-LICENSES.md` criado
- [ ] Docker rebuild executado com sucesso
- [ ] Aplicação acessível em http://localhost:4010
- [ ] Interface mostra "TestPath" em vez de "Hoppscotch"
- [ ] Logos corretos aparecem na interface

---

## 🎯 PRÓXIMOS PASSOS (OPCIONAL)

### Para Comercialização:

1. **Legal** (FUNDAMENTAL!):
   - [ ] Consultar advogado especializado
   - [ ] Registrar marca "TestPath"
   - [ ] Criar Termos de Serviço
   - [ ] Criar Política de Privacidade

2. **Técnico**:
   - [ ] Implementar sistema de licenciamento
   - [ ] Adicionar features premium (SSO, RBAC)
   - [ ] Setup servidor de produção
   - [ ] Configurar domínio próprio

3. **Negócio**:
   - [ ] Definir preços
   - [ ] Criar website
   - [ ] Preparar suporte
   - [ ] Lançar beta

---

## ⚠️ AVISOS IMPORTANTES

### PODE FAZER:
✅ Alterar nome para TestPath
✅ Substituir logos
✅ Modificar funcionalidades
✅ Vender o produto
✅ Hospedar como SaaS
✅ Cobrar por suporte

### DEVE FAZER:
⚠️ Manter arquivo THIRD-PARTY-LICENSES.md
⚠️ Incluir licença MIT original
⚠️ Dar crédito ao Hoppscotch
⚠️ Consultar advogado

### NÃO PODE FAZER:
❌ Remover avisos de copyright
❌ Afirmar que você criou tudo do zero
❌ Usar nome/marca "Hoppscotch"
❌ Responsabilizar autores originais

---

## 🔍 TESTE FINAL

Após completar tudo, teste:

```powershell
# Verificar se está rodando
docker compose --profile dev ps

# Acessar aplicação
start http://localhost:4010

# Verificar logs
docker compose --profile dev logs -f
```

O que verificar:
1. ✅ Nome "TestPath" aparece no título da página
2. ✅ Logo correto aparece na interface
3. ✅ Todas as funcionalidades funcionam
4. ✅ Sem erros no console

---

## 📞 RESUMO RÁPIDO

### Comandos Essenciais:

```powershell
# 1. Copiar logos
Copy-Item "Imagen/Gemini_Generated_Image_j0orhlj0orhlj0or.png" "packages/hoppscotch-common/public/logo.png" -Force

# 2. Substituir textos (usar VS Code Find & Replace)
#    Hoppscotch → TestPath

# 3. Criar THIRD-PARTY-LICENSES.md
#    (copiar template acima)

# 4. Rebuild Docker
docker compose --profile dev down
docker compose --profile dev up -d --build

# 5. Acessar
start http://localhost:4010
```

---

## 💡 DICA FINAL

**Faça uma coisa de cada vez:**
1. Primeiro: Substitua logos ✅
2. Segundo: Substitua textos ✅
3. Terceiro: Crie licença ✅
4. Quarto: Rebuild Docker ✅
5. Quinto: Teste ✅

**Não tente fazer tudo ao mesmo tempo!**

---

Boa sorte com o TestPath! 🚀

*Lembre-se: A licença MIT permite comercialização, mas consultar um advogado é FUNDAMENTAL antes de vender o produto.*

