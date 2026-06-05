#!/bin/bash
# ============================================================
# Script: 01_update.sh
# Descrição: Atualiza os pacotes do sistema Ubuntu
# Projeto: ShopCloud - E-Commerce na Nuvem
# Aluno: Vitor Hugo Tavares | Unidavi
# ============================================================

# Diretório de logs do projeto
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/update.log"

# Garante que o diretório de logs existe
mkdir -p "$LOG_DIR"

# ------------------------------------------------------------
# Função: registrar_log
# Registra uma mensagem com data/hora no arquivo de log
# ------------------------------------------------------------
registrar_log() {
  local mensagem="$1"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $mensagem" | tee -a "$LOG_FILE"
}

# ------------------------------------------------------------
# Função: atualizar_sistema
# Executa apt update e apt upgrade no container Ubuntu
# ------------------------------------------------------------
atualizar_sistema() {
  registrar_log "=== INÍCIO DA ATUALIZAÇÃO DO SISTEMA ==="
  echo ""
  echo "🔄 [ShopCloud] Atualizando lista de pacotes..."

  # Atualiza a lista de pacotes disponíveis
  if apt-get update -y >> "$LOG_FILE" 2>&1; then
    registrar_log "[OK] apt update executado com sucesso."
    echo "✅ Lista de pacotes atualizada."
  else
    registrar_log "[ERRO] Falha no apt update."
    echo "❌ Erro ao atualizar lista de pacotes."
    exit 1
  fi

  echo ""
  echo "⬆️  Atualizando pacotes instalados..."

  # Atualiza os pacotes instalados
  if apt-get upgrade -y >> "$LOG_FILE" 2>&1; then
    registrar_log "[OK] apt upgrade executado com sucesso."
    echo "✅ Pacotes atualizados com sucesso."
  else
    registrar_log "[ERRO] Falha no apt upgrade."
    echo "❌ Erro ao atualizar pacotes."
    exit 1
  fi

  registrar_log "=== ATUALIZAÇÃO CONCLUÍDA ==="
  echo ""
  echo "📋 Log salvo em: $LOG_FILE"
}

# ------------------------------------------------------------
# Execução principal
# ------------------------------------------------------------
echo "============================================"
echo "  ShopCloud — Atualização do Sistema Linux  "
echo "============================================"
atualizar_sistema
echo "============================================"
