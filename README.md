# Trabalho 03 — Linux, Shell Script e Cloud Computing

## Aluno
**Vitor Hugo Tavares**
Sistemas de Informação — Unidavi

## Tema
**Infraestrutura para um Pequeno E-Commerce** 🛒

## Descrição do Projeto

Este projeto simula o ambiente operacional de um pequeno e-commerce hospedado em nuvem. Um container Docker com Ubuntu Server é configurado com Apache para servir um site estático, e scripts Shell automatizam tarefas operacionais como atualização do sistema, backup, deploy, monitoramento, gerenciamento de usuários e geração de relatórios.

O ambiente reproduz rotinas reais de DevOps aplicadas a uma loja virtual, incluindo estrutura de diretórios temática (`/app/ecommerce/produtos`, `/app/ecommerce/pedidos`, etc.), controle de permissões por perfil (operações vs. leitura) e logs de todas as execuções.

## Tecnologias Utilizadas

- Linux Ubuntu 22.04
- Docker
- Docker Compose
- Apache2
- Shell Script (Bash)
- GitHub
- DockerHub

## Estrutura do Projeto

```
trabalho03-cloud-shell/
├── Dockerfile               # Imagem Ubuntu com Apache
├── docker-compose.yml       # Orquestração com volume persistente
├── README.md
├── scripts/
│   ├── 01_update.sh         # Atualização do sistema
│   ├── 02_apache.sh         # Instalação e validação do Apache
│   ├── 03_estrutura.sh      # Estrutura de diretórios do e-commerce
│   ├── 04_backup.sh         # Backup automatizado
│   ├── 05_deploy.sh         # Deploy do site estático
│   ├── 06_processos.sh      # Gerenciamento de processos
│   ├── 07_monitoramento.sh  # Monitoramento de CPU, RAM, disco e Apache
│   ├── 08_usuarios_permissoes.sh  # Usuários, grupos e permissões
│   ├── 09_relatorio.sh      # Relatório operacional completo
│   └── menu.sh              # Menu interativo principal
├── source/
│   ├── index.html           # Página principal do ShopCloud
│   ├── sobre.html           # Página sobre o projeto
│   └── assets/
│       └── style.css        # Estilos do site
├── backups/                 # Backups gerados (.tar.gz)
├── logs/                    # Logs de execução dos scripts
└── evidencias/              # Prints e evidências de execução
```

## Como Executar

### 1. Clonar o repositório

```bash
git clone <URL_DO_REPOSITORIO>
cd trabalho03-cloud-shell
```

### 2. Subir o ambiente Docker

```bash
docker compose up -d --build
```

### 3. Acessar o container

```bash
docker exec -it trabalho03-linux bash
```

### 4. Navegar até os scripts

```bash
cd /app/scripts
chmod +x *.sh
```

### 5. Executar o menu principal

```bash
./menu.sh
```

## Como Acessar o Site no Navegador

Após executar o deploy (`./05_deploy.sh`), acesse:

```
http://localhost:8080
```

## Scripts Disponíveis

| Script | Descrição |
|--------|-----------|
| `01_update.sh` | Atualiza a lista e os pacotes do sistema via apt |
| `02_apache.sh` | Instala, inicia e valida o Apache2 |
| `03_estrutura.sh` | Cria diretórios temáticos do e-commerce |
| `04_backup.sh` | Gera backup `.tar.gz` com timestamp |
| `05_deploy.sh` | Copia o site estático para `/var/www/html` |
| `06_processos.sh` | Lista, busca e encerra processos por parâmetro |
| `07_monitoramento.sh` | Monitora CPU, RAM, disco e Apache com alertas |
| `08_usuarios_permissoes.sh` | Cria usuários/grupos e aplica permissões |
| `09_relatorio.sh` | Gera relatório completo em `logs/relatorio_execucao.txt` |
| `menu.sh` | Menu interativo integrando todos os scripts |

## Como Executar Cada Script

```bash
# Dentro do container, na pasta /app/scripts

./01_update.sh
./02_apache.sh
./03_estrutura.sh
./04_backup.sh
./05_deploy.sh

# Processos (com parâmetros):
./06_processos.sh listar
./06_processos.sh buscar apache
./06_processos.sh matar 1234

./07_monitoramento.sh
./08_usuarios_permissoes.sh
./09_relatorio.sh
```

## Como Executar o Menu Principal

```bash
./menu.sh
```

O menu interativo permite executar todas as rotinas sem precisar digitar os comandos manualmente.

## Estrutura de Diretórios Criada no Container

```
/app/ecommerce/
├── produtos/      → Catálogo de produtos da loja
├── pedidos/       → Controle de pedidos (acesso restrito: pedido_user)
├── clientes/      → Base de clientes (acesso restrito: root)
├── pagamentos/    → Dados de pagamento
├── estoque/       → Controle de estoque (estoque_user, somente leitura)
├── publicacao/    → Arquivos prontos para publicação
├── logs/          → Logs operacionais
└── backups/       → Backups locais do e-commerce
```

## Usuários e Grupos Criados

| Usuário | Grupo | Acesso |
|---------|-------|--------|
| `pedido_user` | `ecommerce_ops` | `/app/ecommerce/pedidos` (770) |
| `estoque_user` | `ecommerce_leitura` | `/app/ecommerce/estoque` (750) |

## Evidências

Consulte a pasta [`evidencias/`](./evidencias/) para prints de:
- Container em execução
- Scripts com permissão de execução
- Execução do script de atualização
- Instalação e validação do Apache
- Estrutura de diretórios criada
- Backup `.tar.gz` gerado
- Deploy realizado e site acessível no navegador
- Monitoramento do sistema
- Usuários e permissões configurados
- Relatório final gerado

## DockerHub

```
docker pull <SEU_USUARIO_DOCKERHUB>/shopcloud-ecommerce:latest
```

> Link: https://hub.docker.com/r/<SEU_USUARIO_DOCKERHUB>/shopcloud-ecommerce

## Uso de IA

Este trabalho foi desenvolvido com apoio do Claude (Anthropic) para estruturação e revisão dos scripts Shell. A IA auxiliou na organização da estrutura de arquivos, sugestão de boas práticas de Shell Script (uso de funções, validações, comentários) e formatação do README.

Todo o conteúdo foi revisado, adaptado ao tema e-commerce e compreendido pelo aluno. Ajustes manuais foram feitos para adequar os scripts ao ambiente Docker (uso de `service` ao invés de `systemctl`, adaptações de paths, etc.).

## Dificuldades Encontradas

- Adaptação do Apache para container Docker: o `systemctl` não funciona em containers, sendo necessário usar `service apache2 start` e verificar via `pgrep`.
- Criação de usuários de sistema sem shell de login (`/usr/sbin/nologin`) para segurança.
- Garantia de idempotência nos scripts (executar múltiplas vezes sem erros).
