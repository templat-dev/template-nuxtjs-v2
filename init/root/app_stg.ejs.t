---
to: <%= rootDirectory %>/app_stg.yaml
force: true
---
runtime: nodejs20
<%_ if (applicationType === 'console') { -%>
service: console-stg
<%_ } else { -%>
service: stg
<%_ } -%>

instance_class: F2

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
