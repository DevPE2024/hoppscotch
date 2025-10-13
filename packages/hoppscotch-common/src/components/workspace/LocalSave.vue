<template>
  <div class="flex items-center space-x-2">
    <HoppButtonSecondary
      :icon="IconUploadCloud"
      :label="t('header.save_workspace')"
      :disabled="isSaving"
      class="!focus-visible:text-emerald-600 !hover:text-emerald-600 h-8 border border-emerald-600/25 bg-emerald-500/10 !text-emerald-500 hover:border-emerald-600/20 hover:bg-emerald-600/20 focus-visible:border-emerald-600/20 focus-visible:bg-emerald-600/20"
      @click="saveWorkspace"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue"
import { useI18n } from "@composables/i18n"
import { useToast } from "~/composables/toast"
import { useService } from "dioc/vue"
import { useReadonlyStream } from "@composables/stream"
import { WorkspaceService } from "~/services/workspace.service"
import { restCollections$ } from "~/newstore/collections"
import IconUploadCloud from "~icons/lucide/upload-cloud"

const t = useI18n()
const toast = useToast()
const isSaving = ref(false)

const workspaceService = useService(WorkspaceService)
const collections = useReadonlyStream(restCollections$, [], "deep")

const saveWorkspace = async () => {
  try {
    isSaving.value = true
    
    // Get current workspace data
    const workspace = workspaceService.currentWorkspace.value
    
    // Create workspace data object
    const workspaceData = {
      id: `local-${Date.now()}`,
      name: `My Workspace - ${new Date().toLocaleDateString()}`,
      type: "local",
      collections: collections.value || [],
      environment: workspace,
      timestamp: new Date().toISOString(),
      version: "1.0"
    }
    
    // Save to localStorage
    const savedWorkspaces = JSON.parse(localStorage.getItem('testpath-workspaces') || '[]')
    savedWorkspaces.push(workspaceData)
    
    // Keep only last 10 workspaces
    if (savedWorkspaces.length > 10) {
      savedWorkspaces.splice(0, savedWorkspaces.length - 10)
    }
    
    localStorage.setItem('testpath-workspaces', JSON.stringify(savedWorkspaces))
    
    toast.success(t('workspace.saved_successfully'))
    
  } catch (error) {
    console.error('Error saving workspace:', error)
    toast.error(t('error.something_went_wrong'))
  } finally {
    isSaving.value = false
  }
}
</script>
