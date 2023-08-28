---
to: "<%= project.plugins.find(p => p.name === 'auth')?.enable ? `${rootDirectory}/plugins/firebase.ts` : null %>"
force: true
---
import {initializeApp} from 'firebase/app'
import {getAuth} from 'firebase/auth'
import {initializeAnalytics} from 'firebase/analytics'
import * as firebaseui from 'firebaseui'
import 'firebaseui/dist/firebaseui.css'

// Your web app's Firebase configuration
<%- project.plugins.find(p => p.name === 'auth')?.parameter %>
const firebaseApp = initializeApp(firebaseConfig)
initializeAnalytics(firebaseApp)
const auth = getAuth(firebaseApp)
const authUI = new firebaseui.auth.AuthUI(auth)

export {auth, authUI}
