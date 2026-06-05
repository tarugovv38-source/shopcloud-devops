#!/bin/bash
# ============================================================
# Script: 09_relatorio.sh
# Descrição: Gera relatório operacional completo do ShopCloud
# Projeto: ShopCloud - E-Commerce na Nuvem
# Aluno: Vitor Hugo Tavares | Unidavi
# ============================================================

LOG_DIR="/app/logs"
RELATORIO="$LOG_DIR/relatorio_execucao.txt"
BASE_DIR="/app/ecommerce"
BACKUP_DIR="/app/backups"

mkdir -p "$LOG_DIR"

# Remove relatório anterior se existir
rm -f "$RELATORIO"

# ------------------------------------------------------------
# Função: linha_separadora
# ------------------------------------------------------------
linha_separadora() {
  echo "============================================" | tee -a "$RELATORIO"
}

# ------------------------------------------------------------
# Função: escrever
# Escreve no terminal e no arquivo de relatório
# ------------------------------------------------------------
escrever() {
  echo "$1" | tee -a "$RELATORIO"
}

# ------------------------------------------------------------
# Função: cabecalho_relatorio
# ------------------------------------------------------------
cabecalho_relatorio() {
  linha_separadora
  escrever "  RELATÓRIO OPERACIONAL — SHOPCLOUD"
  escrever "  E-Commerce na Nuvem — Trabalho 03"
  linha_separadora
  escrever "Aluno     : Vitor Hugo Tavares"
  escrever "Instituição: Unidavi — Sistemas de Informação"
  escrever "Tema      : Infraestrutura para Pequeno E-Commerce"
  escrever "Data/Hora : $(date '+%Y-%m-%d %H:%M:%S')"
  linha_separadora
}

# ------------------------------------------------------------
# Função: relatorio_disco
# ------------------------------------------------------------
relatorio_disco() {
  escrever ""
  escrever ">>> ESPAÇO EM DISCO"
  df -h | tee -a "$RELATORIO"
}

# ------------------------------------------------------------
# Função: relatorio_diretorios
# ------------------------------------------------------------
relatorio_diretorios() {
  escrever ""
  escrever ">>> USO DOS DIRETÓRIOS DO PROJETO"

  if [ -d "$BASE_DIR" ]; then
    du -sh "$BASE_DIR"/* 2>/dev/null | tee -a "$RELATORIO"
  else
    escrever "   Estrutura $BASE_DIR não encontrada. Execute 03_estrutura.sh"
  fi
}

# ------------------------------------------------------------
# Função: relatorio_apache
# ------------------------------------------------------------
relatorio_apache() {
  escrever ""
  escrever ">>> STATUS DO APACHE"

  if pgrep -x "apache2" > /dev/null; then
    escrever "   [OK] Apache está em execução."
    local versao
    versao=$(apache2 -v 2>/dev/null | head -1)
    escrever "   Versão: $versao"
  else
    escrever "   [ALERTA] Apache NÃO está em execução!"
  fi
}

# ------------------------------------------------------------
# Função: relatorio_backups
# ------------------------------------------------------------
relatorio_backups() {
  escrever ""
  escrever ">>> ÚLTIMOS BACKUPS"

  if ls "$BACKUP_DIR"/*.tar.gz > /dev/null 2>&1; then
    ls -lht "$BACKUP_DIR"/*.tar.gz | head -5 | tee -a "$RELATORIO"
  else
    escrever "   Nenhum backup encontrado em $BACKUP_DIR"
  fi
}

# ------------------------------------------------------------
# Função: relatorio_logs
# ------------------------------------------------------------
relatorio_logs() {
  escrever ""
  escrever ">>> ARQUIVOS DE LOG"

  ls -lh "$LOG_DIR"/*.log 2>/dev/null | tee -a "$RELATORIO" || escrever "   Nenhum log encontrado."
}

# ------------------------------------------------------------
# Função: relatorio_publicacao
# ------------------------------------------------------------
relatorio_publicacao() {
  escrever ""
  escrever ">>> ARQUIVOS PUBLICADOS NO APACHE (/var/www/html)"

  if [ -d "/var/www/html" ]; then
    ls -lh /var/www/html | tee -a "$RELATORIO"
  else
    escrever "   Diretório /var/www/html não encontrado."
  fi
}

# ------------------------------------------------------------
# Função: relatorio_usuarios
# ------------------------------------------------------------
relatorio_usuarios() {
  escrever ""
  escrever ">>> USUÁRIOS E GRUPOS DO SHOPCLOUD"

  escrever "Grupos:"
  getent group ecommerce_ops ecommerce_leitura 2>/dev/null | tee -a "$RELATORIO" \
    || escrever "   Grupos não criados ainda."

  escrever ""
  escrever "Usuários de sistema:"
  for u in pedido_user estoque_user; do
    id "$u" 2>/dev/null | tee -a "$RELATORIO" || escrever "   $u: não encontrado"
  done

  escrever ""
  escrever "Permissões nos diretórios:"
  ls -ld "$BASE_DIR"/pedidos "$BASE_DIR"/estoque "$BASE_DIR"/clientes "$BASE_DIR"/logs 2>/dev/null \
    | tee -a "$RELATORIO" || escrever "   Estrutura não criada ainda."
}

# ------------------------------------------------------------
# Função: rodape_relatorio
# ------------------------------------------------------------
rodape_relatorio() {
  escrever ""
  linha_separadora
  escrever "  Relatório gerado em: $(date '+%Y-%m-%d %H:%M:%S')"
  escrever "  Arquivo: $RELATORIO"
  linha_separadora
}

# ------------------------------------------------------------
# Execução principal
# ------------------------------------------------------------
cabecalho_relatorio
relatorio_disco
relatorio_diretorios
relatorio_apache
relatorio_backups
relatorio_logs
relatorio_publicacao
relatorio_usuarios
rodape_relatorio

echo ""
echo "✅ Relatório gerado em: $RELATORIO"
