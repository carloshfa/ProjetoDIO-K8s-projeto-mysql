# Anotações Técnicas — Histórico e Justificativas

Objetivo
-------
Este arquivo documenta, em linguagem técnica concisa, o histórico de mudanças, motivações e decisões arquiteturais do projeto. Deve ser atualizado sempre que uma alteração relevante for aplicada (infra, manifests, scripts, código, CI/CD).

Formato das entradas
---------------------
- Data: YYYY-MM-DD
- Autor: pessoa/automação
- Arquivos afetados: lista de caminhos
- Mudança: resumo curto
- Justificativa / Porquê: motivo técnico e impacto esperado
- Comandos / Observações: como validar ou reverter

Entradas iniciais
-----------------

Data: 2026-07-17
Autor: GitHub Copilot (assistente)
Arquivos afetados:
- `database/sql.sql`
- `backend/index.php`
- `frontend/js.js`
- `README.md`
- `deployment.yml`

Mudança:
- Atualizado schema `mensagens` para usar `id` auto-increment.
- Substituída inserção vulnerável por prepared statements no `backend/index.php`.
- Atualizado `frontend/js.js` para enviar POST JSON ao endpoint `http://backend/index.php` e tratar respostas de erro.
- Adicionado documentação no `README.md` sobre endpoint do backend e instruções de ajuste.
- Adicionado `revisionHistoryLimit`, `strategy` (RollingUpdate), labels de versão e `change-cause` annotations em `deployment.yml` para permitir `kubectl rollout history`.

Justificativa / Porquê:
- `id` auto-increment evita a necessidade de gerar IDs no cliente e previne colisões com inserções concorrentes.
- Prepared statements previnem SQL injection e melhoram segurança geral do backend.
- Frontend ajustado para consumir API JSON e exibir mensagens de erro ao usuário; padrão `http://backend` é resolvível dentro do cluster Kubernetes.
- Rollout history e annotations permitem auditoria de versões e uso de `kubectl rollout history` para diagnóstico e auditoria.

Comandos / Observações:
- Validar tabela: `docker exec -it <mysql-container> mysql -u root -p meubanco -e "DESCRIBE mensagens;"`
- Testar backend (local): `curl -X POST -d "nome=Teste&email=t@t.com&comentario=ola" http://localhost/index.php`
- Ver rollout history: `kubectl rollout history deployment/backend` e `kubectl rollout history deployment/mysql`
- Registrar change-cause manualmente ao aplicar: `kubectl apply -f deployment.yml --record --change-cause="Descrição da mudança"`


Sugestões operacionais
----------------------
- Sempre incluir `app.kubernetes.io/version` nas labels ao preparar uma nova imagem/versionamento da aplicação.
- Ao fazer alterações em infra ou manifests críticos, coloque uma entrada nesta anotação com o motivo de negócio e técnica.
- Considere adicionar um script `scripts/rollout-deploy.sh` que execute `kubectl set image` + `kubectl rollout status` e registre o `change-cause` automaticamente.

Como contribuir
----------------
- Edite este arquivo adicionando uma entrada no topo com Data/Autor/Arquivos/Mudança/Justificativa.
- Mantenha o texto objetivo e inclua comandos de verificação sempre que possível.

---

Arquivo gerado automaticamente como ponto de partida. Atualize conforme necessário.
