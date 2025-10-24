  <template>
    <Teleport to="body">
      <div
        v-if="show"
        class="fixed inset-0 bg-black/50 backdrop-blur-sm z-[9999] flex items-center justify-center p-4"
        @click="handleBackdropClick"
      >
        <div
          class="bg-gray-900 rounded-2xl border border-gray-700 overflow-y-auto shadow-2xl w-full max-w-4xl max-h-[80vh]"
          @click.stop
        >
      <!-- Header -->
      <div class="flex items-center justify-between p-6 border-b border-gray-700">
        <div>
          <h2 class="text-2xl font-bold text-white">Affinify Ecosystem</h2>
          <p class="text-gray-400 mt-1">Choose an application to explore</p>
        </div>
        <button
          @click="emit('close')"
          class="p-2 hover:bg-gray-800 rounded-lg transition-colors z-10 relative"
          title="Fechar"
        >
          <icon-lucide-x class="w-6 h-6 text-gray-400 hover:text-white" />
        </button>
      </div>

      <!-- Apps Grid -->
      <div class="p-6">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <div
            v-for="app in ecosystemApps"
            :key="app.name"
            :class="`group relative overflow-hidden rounded-xl border border-gray-700 cursor-pointer transition-all duration-300 hover:scale-105 hover:shadow-2xl bg-gradient-to-br ${app.gradient}`"
            @click="handleAppClick(app)"
          >
            <div class="p-6 h-32 flex flex-col justify-between">
              <!-- App Icon -->
              <div class="flex items-center justify-between">
                <div class="w-12 h-12 rounded-full bg-white/20 backdrop-blur-sm flex items-center justify-center border-2 border-white/30">
                  <span class="text-2xl font-bold text-white">{{ app.icon }}</span>
                </div>
                <icon-lucide-external-link class="w-5 h-5 text-white/70 group-hover:text-white transition-colors" />
              </div>
              
              <!-- App Info -->
              <div>
                <h3 class="text-xl font-bold text-white mb-1 group-hover:text-white/90">
                  {{ app.name }}
                </h3>
                <p class="text-sm text-white/80 group-hover:text-white/70">
                  {{ app.description }}
                </p>
              </div>
            </div>

            <!-- Hover Effect Overlay -->
            <div class="absolute inset-0 bg-white/5 opacity-0 group-hover:opacity-100 transition-opacity duration-300 pointer-events-none" />
          </div>
        </div>
      </div>

      <!-- Footer -->
      <div class="p-6 border-t border-gray-700 bg-gray-800/50">
        <p class="text-center text-gray-400 text-sm">
          All applications are part of the Affinify ecosystem and work seamlessly together
        </p>
      </div>
    </div>
  </div>
    </Teleport>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useI18n } from '@composables/i18n'
import { useToast } from '@composables/toast'
import { platform } from '~/platform'
import IconLucideExternalLink from '~icons/lucide/external-link'
import IconLucideX from '~icons/lucide/x'

const t = useI18n()
const toast = useToast()

interface EcosystemApp {
  name: string
  description: string
  url: string
  gradient: string
  icon: string
  requiresSSO?: boolean
}

const ecosystemApps: EcosystemApp[] = [
  {
    name: 'Prodify',
    description: 'Task Management & Productivity',
    url: import.meta.env.ECOSYSTEM_PRODIFY_URL || 'http://localhost:8001',
    gradient: 'from-purple-500 via-blue-500 to-pink-500',
    icon: 'P',
    requiresSSO: false
  },
  {
    name: 'OnScope',
    description: 'Visual Web Editor',
    url: import.meta.env.ECOSYSTEM_ONSCOPE_URL || 'http://localhost:8002',
    gradient: 'from-red-500 via-orange-500 to-pink-500',
    icon: 'O',
    requiresSSO: true
  },
  {
    name: 'JazzUp',
    description: 'Collaborative Canvas',
    url: import.meta.env.ECOSYSTEM_JAZZUP_URL || 'http://localhost:5173',
    gradient: 'from-blue-400 via-cyan-400 to-green-400',
    icon: 'J',
    requiresSSO: true
  },
  {
    name: 'DeepQuest',
    description: 'AI-Powered Search Engine',
    url: import.meta.env.ECOSYSTEM_DEEPQUEST_URL || 'http://localhost:3001',
    gradient: 'from-purple-600 via-blue-600 to-pink-600',
    icon: 'D',
    requiresSSO: false
  },
  {
    name: 'OpenUIX',
    description: 'AI Interface Platform',
    url: import.meta.env.ECOSYSTEM_OPENUIX_URL || 'http://localhost:5050',
    gradient: 'from-pink-500 via-yellow-500 to-blue-500',
    icon: 'O',
    requiresSSO: true
  },
  {
    name: 'TestPath',
    description: 'API Testing & Development',
    url: import.meta.env.ECOSYSTEM_TESTPATH_URL || 'http://localhost:3000',
    gradient: 'from-teal-400 via-pink-400 to-purple-400',
    icon: 'T',
    requiresSSO: false
  }
]

const props = defineProps<{
  show: boolean
}>()

const emit = defineEmits<{
  (e: 'close'): void
}>()

const handleBackdropClick = () => {
  emit('close')
}

const handleKeydown = (event: KeyboardEvent) => {
  if (event.key === 'Escape') {
    emit('close')
  }
}

onMounted(() => {
  document.addEventListener('keydown', handleKeydown)
})

onUnmounted(() => {
  document.removeEventListener('keydown', handleKeydown)
})

const handleAppClick = (app: EcosystemApp) => {
  try {
    const currentUser = platform.auth.getCurrentUser()
    
    let finalUrl = app.url

    // Se o app requer SSO e há usuário logado
    if (app.requiresSSO && currentUser) {
      // Criar token SSO simples (base64)
      const ssoData = {
        email: currentUser.email,
        name: currentUser.displayName,
        uid: currentUser.uid,
        timestamp: Date.now(),
        source: 'testpath'
      }
      const ssoToken = btoa(JSON.stringify(ssoData))
      
      // Adicionar token SSO na URL
      const separator = finalUrl.includes('?') ? '&' : '?'
      finalUrl = `${finalUrl}${separator}sso_token=${ssoToken}&email=${encodeURIComponent(currentUser.email)}`
      
      console.log(`🔐 Abrindo ${app.name} com SSO:`, currentUser.email)
    } else if (app.requiresSSO && !currentUser) {
      toast.error('Login necessário para acessar este aplicativo')
      return
    }
    
    console.log(`📂 Abrindo ${app.name}:`, finalUrl)
    window.open(finalUrl, '_blank')
    
  } catch (error) {
    console.error(`❌ Erro ao abrir ${app.name}:`, error)
    toast.error('Algo deu errado')
  }
}
</script>

