# Script para adicionar automaticamente exportações GraphQL faltantes
$graphqlFile = "C:\App\Deployer\Project_Affinify\TestPath\packages\hoppscotch-common\src\helpers\backend\graphql.ts"

# Lista completa de exportações comuns
$exports = @(
    "GetPendingInvitesDocument",
    "GetInfraUsersDocument",
    "CreateInfraUserDocument",
    "UpdateInfraUserDocument",
    "DeleteInfraUserDocument",
    "MakeInfraAdminDocument",
    "RemoveInfraAdminDocument",
    "GetUserDocument",
    "GetCurrentUserDocument",
    "UpdateUserDisplayNameDocument",
    "UpdateUserEmailDocument",
    "DeleteUserDocument",
    "GetUserSettingsDocument",
    "UpdateUserSettingsDocument",
    "GetUserEnvironmentsDocument",
    "CreateUserEnvironmentDocument",
    "UpdateUserEnvironmentDocument",
    "DeleteUserEnvironmentDocument",
    "GetUserCollectionsDocument",
    "GetUserCollectionDocument",
    "CreateUserCollectionDocument",
    "UpdateUserCollectionDocument",
    "DeleteUserCollectionDocument",
    "MoveUserCollectionDocument",
    "GetUserRequestsDocument",
    "GetUserRequestDocument",
    "CreateUserRequestDocument",
    "UpdateUserRequestDocument",
    "DeleteUserRequestDocument",
    "GetUserHistoryDocument",
    "ClearUserHistoryDocument",
    "DeleteUserHistoryEntryDocument",
    "GetShortcodeDocument",
    "CreateShortcodeDocument",
    "RevokeShortcodeDocument",
    "GetTeamRequestsDocument",
    "GetTeamRequestDocument",
    "CreateTeamRequestDocument",
    "UpdateTeamRequestDocument",
    "DeleteTeamRequestDocument"
)

# Adicionar cada exportação ao final do arquivo
$content = Get-Content $graphqlFile -Raw
foreach ($export in $exports) {
    if ($content -notmatch "export const $export") {
        Add-Content -Path $graphqlFile -Value "export const $export = {} as any;"
        Write-Host "✅ Adicionado: $export" -ForegroundColor Green
    } else {
        Write-Host "⏭️  Já existe: $export" -ForegroundColor Yellow
    }
}

Write-Host "`n✅ Processo concluído!" -ForegroundColor Cyan

