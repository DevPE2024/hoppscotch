import { defineConfig } from "vite"
import Vue from "@vitejs/plugin-vue"
import { resolve } from "path"

export default defineConfig({
  plugins: [Vue()],
  server: {
    port: 3000,
    hmr: {
      overlay: false
    }
  },
  resolve: {
    alias: {
      "@": resolve(__dirname, "./src"),
      "~": resolve(__dirname, "./src"),
      "@platform": resolve(__dirname, "./src/platform"),
      "@hoppscotch/common": resolve(__dirname, "../hoppscotch-common/src"),
      "@hoppscotch/kernel": resolve(__dirname, "../hoppscotch-kernel/src"),
      "@hoppscotch/data": resolve(__dirname, "../hoppscotch-data/src"),
    }
  },
  define: {
    "process.env": {},
    "process.platform": '"browser"',
  },
  build: {
    rollupOptions: {
      onwarn(warning, warn) {
        if (warning.code === 'UNRESOLVED_IMPORT') return
        warn(warning)
      }
    }
  }
})
