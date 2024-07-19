---
to: <%= rootDirectory %>/plugins/env.ts
force: true
---
import globalAxios from 'axios'

export default function () {
  if (process && process.env && process.env.NUXT_ENV_API_BASE_PATH) {
    globalAxios.defaults.baseURL = process.env.NUXT_ENV_API_BASE_PATH
  }
}
