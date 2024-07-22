---
to: "<%= project.plugins.find(p => p.name === 'auth')?.enable ? `${rootDirectory}/middleware/auth.ts` : null %>"
force: true
---
import {Context} from '@nuxt/types'
import {firebaseAuth} from '~/plugins/firebase'

export default async ({route, redirect}: Context) => {
  if (route.path === '/login') {
    return
  }
  if (!firebaseAuth.currentUser) {
    return redirect('/login')
  }
}
