---
to: <%= rootDirectory %>/tsconfig.json
force: true
---
{
  "compilerOptions": {
    "target": "ES2018",
    "module": "ESNext",
    "moduleResolution": "Node",
    "lib": [
      "ESNext",
      "ESNext.AsyncIterable",
      "DOM"
    ],
    "esModuleInterop": true,
    "allowJs": true,
    "sourceMap": true,
    "strict": true,
    "noEmit": true,
    "experimentalDecorators": true,
    "baseUrl": ".",
    "paths": {
      "~/*": [
        "./*"
      ],
      "@/*": [
        "./*"
      ]
    },
    "types": [
      "@nuxt/types",
      "@nuxtjs/axios",
      "@types/node",
      "@nuxtjs/vuetify",
<%_ if (project.plugins.find(p => p.name === 'pay')?.enable) { -%>
      "stripe-v3"
<%_ } -%>
    ],
  },
  "exclude": [
    "node_modules",
    ".nuxt",
    "dist"
  ]
}
