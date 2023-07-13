---
to: <%= rootDirectory %>/env/.env.prod
force: true
---
NUXT_ENV_API_BASE_PATH=<%= project.serverConfig.production.scheme %>://<%= project.serverConfig.production.host %><%= project.serverConfig.production.basePath %>
