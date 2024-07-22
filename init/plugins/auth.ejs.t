---
to: "<%= project.plugins.find(p => p.name === 'auth')?.enable ? `${rootDirectory}/plugins/auth.ts` : null %>"
force: true
---
import {Context} from '@nuxt/types'
import globalAxios from 'axios'
import {onAuthStateChanged} from 'firebase/auth'
import {firebaseAuth} from '~/plugins/firebase'

export default async ({route}: Context) => {
  await new Promise((resolve) => {
    onAuthStateChanged(firebaseAuth, async (user) => {
      if (user) {
        globalAxios.interceptors.request.use(async request => {
          request.headers.common = {'Authorization': `Bearer ${await user.getIdToken()}`}
          return request
        })
      }
      resolve(null)
    })
  })
}
