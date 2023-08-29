---
to: "<%= project.plugins.find(p => p.name === 'auth')?.enable ? `${rootDirectory}/pages/login.vue` : null %>"
force: true
---
<template>
  <v-layout justify-center>
    <v-flex class="login-panel pa-8 mt-8" md6 sm8 xs12>
      <img alt="ロゴ" class="logo mb-4" src="@/assets/image/logo.png">
      <span class="login-headline">ログイン</span>
      <div id="firebaseui-auth-container"></div>
    </v-flex>
  </v-layout>
</template>

<script lang="ts">
import {Component, mixins} from 'nuxt-property-decorator'
import {GoogleAuthProvider} from '@firebase/auth'
import Base from '@/mixins/base'
import {firebaseAuthUI} from '@/plugins/firebase'
import {vxm} from '@/store'

const AUTH_UI_DEFAULT_CONFIG = {
  signInFlow: 'popup',
  signInOptions: [
    {
      provider: GoogleAuthProvider.PROVIDER_ID,
      scopes: []
    }
  ]
}

@Component
export default class LoginPage extends mixins(Base) {
  mounted() {
    if (firebaseAuthUI.isPendingRedirect()) {
      vxm.app.showLoading()
    }
    let signInSuccessUrl = '/'
    if (this.$route.query.r) {
      signInSuccessUrl = this.$route.query.r.toString()
    }
    firebaseAuthUI.start('#firebaseui-auth-container', {
      ...AUTH_UI_DEFAULT_CONFIG,
      signInSuccessUrl
    })
  }
}
</script>

<style scoped>
.logo {
  width: 120px;
  height: 120px;
}

.login-headline {
  font-size: 20px;
}

.login-panel {
  background-color: rgba(0, 0, 0, 0.02);
  display: flex;
  flex-direction: column;
  align-items: center;
  border-radius: 4px;
}

#firebaseui-auth-container >>> ul {
  padding-left: 0;
}
</style>
