---
to: <%= rootDirectory %>/import-resolver.js
force: true
---
/* eslint-disable no-undef */
// r.f. https://youtrack.jetbrains.com/issue/WEB-22717#focus=streamItem-27-1558931-0-0
System.config({
  paths: {
    '@/*': './*'
  }
})
