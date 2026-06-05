#!/bin/bash
# ============================================================
# Script: 04_backup.sh
# Descrição: Gera backup comprimido dos dados do ShopCloud
# Projeto: ShopCloud - E-Commerce na Nuvem
# Aluno: Vitor Hugo Tavares | Unidavi
# ============================================================

# Variáveis de diretório
ORIGEM="/app/ecommerce"
DESTINO="/app/backups"
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/backup.log"

# Nome do arquivo com data e hora
DATA_HORA=$(date '+%Y-%m-%d_%H-%M')
NOME_BACKUP="backup_ecommerce_${DATA_HORA}.tar.gz"
CAMINHO_BACKUP="$DESTINO/$NOME_BACKUP"

mkdir -p "$DESTINO" "$LOG_DIR"

# ------------------------------------------------------------
# Função: registrar_log
# ------------------------------------------------------------
registrar_log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ------------------------------------------------------------
# Função: verificar_origem
# Valida se o diretório de origem existe antes de fazer backup
# ------------------------------------------------------------
verificar_origem() {
  if [ ! -d "$ORIGEM" ]; then
    registrar_log "[ERRO] Diretório de origem não encontrado: $ORIGEM"
    echo "❌ Diretório $ORIGEM não existe. Execute primeiro o 03_estrutura.sh"
    exit 1
  fi
  registrar_log "[OK] Diretório de origem verificado: $ORIGEM"
}

# ------------------------------------------------------------
# Função: gerar_backup
# Compacta o diretório de origem em .tar.gz com timestamp
# ------------------------------------------------------------
gerar_backup() {
  echo "📦 Gerando backup de $ORIGEM..."
  registrar_log "[INFO] Iniciando backup: $NOME_BACKUP"

  # Cria o arquivo .tar.gz
  if tar -czf "$CAMINHO_BACKUP" -C "$(dirname "$ORIGEM")" "$(basename "$ORIGEM")" 2>> "$LOG_FILE"; then
    registrar_log "[OK] Backup criado: $CAMINHO_BACKUP"
    echo "✅ Backup gerado: $NOME_BACKUP"
  else
    registrar_log "[ERRO] Falha ao criar backup."
    echo "❌ Erro ao gerar backup."
    exit 1
  fi
}

# ------------------------------------------------------------
# Função: validar_backup
# Verifica se o arquivo de backup foi criado corretamente
# ------------------------------------------------------------
validar_backup() {
  echo ""
  echo "🔍 Validando backup..."

  if [ -f "$CAMINHO_BACKUP" ]; then
    local tamanho
    tamanho=$(du -sh "$CAMINHO_BACKUP" | cut -f1)
    registrar_log "[OK] Backup validado. Tamanho: $tamanho"
    echo "✅ Arquivo confirmado: $NOME_BACKUP (Tamanho: $tamanho)"
  else
    registrar_log "[ERRO] Arquivo de backup não encontrado após criação."
    echo "❌ Arquivo de backup não encontrado."
    exit 1
  fi
}

# ------------------------------------------------------------
# Função: listar_backups
# Exibe os backups existentes no diretório de destino
# ------------------------------------------------------------
listar_backups() {
  echo ""
  echo "📂 Backups disponíveis em $DESTINO:"
  ls -lh "$DESTINO"/*.tar.gz 2>/dev/null || echo "   Nenhum backup encontrado."
}

# ------------------------------------------------------------
# Execução principal
# ------------------------------------------------------------
echo "============================================"
echo "  ShopCloud — Backup Automatizado           "
echo "============================================"
verificar_origem
gerar_backup
validar_backup
listar_backups
registrar_log "=== BACKUP CONCLUÍDO ==="
echo ""
echo "📋 Log salvo em: $LOG_FILE"
echo "============================================"
