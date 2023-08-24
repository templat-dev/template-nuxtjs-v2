---
to: "<%= project.plugins.find(p => p.name === 'auth')?.enable ? `${rootDirectory}/plugins/firebase.ts` : null %>"
force: true
---
import firebase from 'firebase/app'
import 'firebase/analytics'
import 'firebase/auth'
import 'firebaseui/dist/firebaseui.css'
import * as firebaseui from 'firebaseui'

// Your web app's Firebase configuration
<%- project.plugins.find(p => p.name === 'auth')?.parameter %>
if (!firebase.apps.length) {
  firebase.initializeApp(firebaseConfig)
  firebase.analytics()
}
const auth = firebase.auth()
const authUI = new firebaseui.auth.AuthUI(auth)

export {auth, authUI}
