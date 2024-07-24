---
to: <%= rootDirectory %>/app_stg.yaml
force: true
---
runtime: nodejs20

instance_class: F2

<%_ if (applicationType === 'web' && branchName === 'stg') { -%>
service: stg
<%_ } -%>
<%_ if (applicationType === 'console' && branchName === 'stg') { -%>
service: console-stg
<%_ } -%>

handlers:
  - url: /_nuxt
    static_dir: .nuxt/dist/client
    secure: always

  - url: /(.*\.(gif|png|jpg|ico|txt))$
    static_files: static/\1
    upload: static/.*\.(gif|png|jpg|ico|txt)$
    secure: always

  - url: /.*
    script: auto
    secure: always

env_variables:
  HOST: '0.0.0.0'
  NODE_ENV: 'stg'
