---
to: <%= rootDirectory %>/package.json
force: true
---
{
  "name": "<%= project.projectName %>",
  "version": "1.0.0",
  "description": "<%= project.projectName %>",
  "author": "TemPlat Console",
  "private": true,
  "scripts": {
    "dev": "nuxt --dotenv ./env/.env",
    "dev:dev": "nuxt --dotenv ./env/.env.dev",
    "dev:stg": "nuxt --dotenv ./env/.env.stg",
    "dev:prod": "nuxt --dotenv ./env/.env.prod",
    "build": "nuxt build --dotenv ./env/.env",
    "build:dev": "nuxt build --dotenv ./env/.env.dev",
    "build:stg": "nuxt build --dotenv ./env/.env.stg",
    "build:prod": "nuxt build --dotenv ./env/.env.prod",
    "start": "nuxt start",
    "generate": "nuxt generate"
  },
  "dependencies": {
    "@nuxtjs/axios": "^5.13.6",
<%_ if (project.plugins.find(p => p.name === 'pay')?.enable) { -%>
    "@stripe/stripe-js": "^1.17.1",
<%_ } -%>
    "date-fns": "^2.30.0",
<%_ if (project.plugins.find(p => p.name === 'auth')?.enable) { -%>
    "firebase": "^10.3.0",
    "firebaseui": "^6.1.0",
<%_ } -%>
    "lodash-es": "^4.17.21",
    "nuxt": "^2.17.1",
    "vue": "^2.7.14",
    "nuxt-property-decorator": "^2.9.1",
    "vuex-class-component": "^2.3.6"
  },
  "devDependencies": {
    "@nuxt/types": "^2.15.8",
    "@nuxt/typescript-build": "^2.1.0",
    "@nuxtjs/vuetify": "^1.12.3",
    "@openapitools/openapi-generator-cli": "^1.0.18-5.0.0-beta2",
<%_ if (project.plugins.find(p => p.name === 'pay')?.enable) { -%>
    "@types/lodash-es": "^4.17.8"
    "@types/stripe-v3": "^3.1.25"
<%_ } else { -%>
    "@types/lodash-es": "^4.17.8"
<%_ } -%>
  },
  "resolutions": {
    "//": "https://stackoverflow.com/questions/67631879/nuxtjs-vuetify-throwing-lots-of-using-for-division-is-deprecated-and-will-be",
    "@nuxtjs/vuetify/**/sass": "1.32.12"
  }
}
