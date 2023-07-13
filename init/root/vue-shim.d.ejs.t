---
to: <%= rootDirectory %>/vue-shim.d.ts
force: true
---
declare module '*.vue' {
  import Vue from 'vue'
  export default Vue
}
