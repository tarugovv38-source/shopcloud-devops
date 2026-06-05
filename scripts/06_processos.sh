#!/bin/bash
# ============================================================
# Script: 06_processos.sh
# Descrição: Gerencia processos do ambiente ShopCloud
# Uso: ./06_processos.sh [listar | buscar <nome> | matar <PID>]
# Projeto: ShopCloud - E-Commerce na Nuvem
# Aluno: Vitor Hugo Tavares | Unidavi
# ============================================================

LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/processos.log"

mkdir -p "$LOG_DIR"

# ------------------------------------------------------------
# Função: registrar_log
# ------------------------------------------------------------
registrar_log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# ------------------------------------------------------------
# Função: listar_processos
# Exibe os processos ativos do sistema
# ------------------------------------------------------------
listar_processos() {
  echo ""
  echo "📋 Processos ativos no ShopCloud Linux:"
  echo "--------------------------------------------"
  ps aux --sort=-%cpu | head -20
  registrar_log "[INFO] Listagem de processos executada."
}

# ------------------------------------------------------------
# Função: buscar_processo
# Busca um processo pelo nome informado como argumento
# ------------------------------------------------------------
buscar_processo() {
  local nome="$1"

  if [ -z "$nome" ]; then
    echo "❌ Informe o nome do processo. Exemplo: ./06_processos.sh buscar apache"
    exit 1
  fi

  echo ""
  echo "🔍 Buscando processo: '$nome'"
  echo "--------------------------------------------"

  local resultado
  resultado=$(pgrep -a "$nome" 2>/dev/null)

  if [ -z "$resultado" ]; then
    echo "⚠️  Nenhum processo encontrado com o nome '$nome'."
    registrar_log "[INFO] Busca por '$nome': nenhum resultado."
  else
    echo "$resultado"
    registrar_log "[INFO] Busca por '$nome': encontrado(s)."
  fi
}

# ------------------------------------------------------------
# Função: matar_processo
# Encerra um processo pelo PID informado
# Impede execução sem PID por segurança
# ------------------------------------------------------------
matar_processo() {
  local pid="$1"

  # Validação de segurança: PID obrigatório
  if [ -z "$pid" ]; then
    echo "❌ [SEGURANÇA] PID obrigatório. Exemplo: ./06_processos.sh matar 1234"
    echo "   Use './06_processos.sh listar' para ver os PIDs disponíveis."
    registrar_log "[BLOQUEADO] Tentativa de matar processo sem PID informado."
    exit 1
  fi

  # Verifica se o PID é um número válido
  if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
    echo "❌ PID inválido: '$pid'. Informe apenas números."
    exit 1
  fi

  # Verifica se o processo existe
  if ! kill -0 "$pid" 2>/dev/null; then
    echo "⚠️  Processo com PID $pid não encontrado."
    registrar_log "[AVISO] PID $pid não encontrado."
    exit 1
  fi

  echo "⚠️  Encerrando processo PID $pid..."
  if kill "$pid" 2>/dev/null; then
    registrar_log "[OK] Processo PID $pid encerrado."
    echo "✅ Processo $pid encerrado com sucesso."
  else
    registrar_log "[ERRO] Falha ao encerrar PID $pid."
    echo "❌ Erro ao encerrar processo $pid. Verifique permissões."
  fi
}

# ------------------------------------------------------------
# Execução principal — roteamento por parâmetro
# ------------------------------------------------------------
echo "============================================"
echo "  ShopCloud — Gerenciamento de Processos    "
echo "============================================"

ACAO="$1"
PARAMETRO="$2"

case "$ACAO" in
  listar)
    listar_processos
    ;;
  buscar)
    buscar_processo "$PARAMETRO"
    ;;
  matar)
    matar_processo "$PARAMETRO"
    ;;
  *)
    echo ""
    echo "📖 Uso: ./06_processos.sh [opção]"
    echo ""
    echo "   listar           — Lista todos os processos ativos"
    echo "   buscar <nome>    — Busca processo por nome"
    echo "   matar  <PID>     — Encerra processo pelo PID"
    echo ""
    echo "Exemplos:"
    echo "   ./06_processos.sh listar"
    echo "   ./06_processos.sh buscar apache"
    echo "   ./06_processos.sh matar 1234"
    ;;
esac

echo "============================================"
