#!/bin/bash
# ============================================================
# Script: 07_monitoramento.sh
# Descrição: Monitora CPU, RAM, disco e Apache do ShopCloud
# Projeto: ShopCloud - E-Commerce na Nuvem
# Aluno: Vitor Hugo Tavares | Unidavi
# ============================================================

LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/monitoramento.log"

# Limites para alertas (em %)
LIMITE_CPU=80
LIMITE_MEM=80
LIMITE_DISCO=85

mkdir -p "$LOG_DIR"

# ------------------------------------------------------------
# Função: registrar_log
# ------------------------------------------------------------
registrar_log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ------------------------------------------------------------
# Função: monitorar_cpu
# Exibe uso de CPU e emite alerta se acima do limite
# ------------------------------------------------------------
monitorar_cpu() {
  # Calcula uso de CPU somando user + system via /proc/stat
  local cpu_uso
  cpu_uso=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 | tr -d ' ')

  # Fallback caso top não retorne valor numérico
  if ! [[ "$cpu_uso" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
    cpu_uso=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.0f", usage}')
  fi

  echo "🖥️  CPU: ${cpu_uso}% em uso"
  registrar_log "[CPU] Uso: ${cpu_uso}%"

  # Alerta se uso de CPU estiver acima do limite
  if (( $(echo "$cpu_uso > $LIMITE_CPU" | bc -l 2>/dev/null || echo 0) )); then
    echo "   ⚠️  [ALERTA] Uso de CPU acima de ${LIMITE_CPU}%!"
    registrar_log "[ALERTA] CPU acima de ${LIMITE_CPU}%: ${cpu_uso}%"
  fi
}

# ------------------------------------------------------------
# Função: monitorar_memoria
# Exibe uso de RAM e emite alerta se acima do limite
# ------------------------------------------------------------
monitorar_memoria() {
  local mem_total mem_usado mem_pct
  mem_total=$(free -m | awk '/^Mem:/{print $2}')
  mem_usado=$(free -m | awk '/^Mem:/{print $3}')
  mem_pct=$(awk "BEGIN {printf \"%.0f\", ($mem_usado/$mem_total)*100}")

  echo "💾 Memória RAM: ${mem_usado}MB / ${mem_total}MB (${mem_pct}%)"
  registrar_log "[MEM] Uso: ${mem_pct}% (${mem_usado}/${mem_total} MB)"

  if [ "$mem_pct" -gt "$LIMITE_MEM" ]; then
    echo "   ⚠️  [ALERTA] Uso de memória acima de ${LIMITE_MEM}%!"
    registrar_log "[ALERTA] Memória acima de ${LIMITE_MEM}%: ${mem_pct}%"
  fi
}

# ------------------------------------------------------------
# Função: monitorar_disco
# Exibe uso de disco e emite alerta se acima do limite
# ------------------------------------------------------------
monitorar_disco() {
  local disco_uso
  disco_uso=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

  echo "💿 Disco (/): ${disco_uso}% em uso"
  registrar_log "[DISCO] Uso: ${disco_uso}%"

  if [ "$disco_uso" -gt "$LIMITE_DISCO" ]; then
    echo "   ⚠️  [ALERTA] Uso de disco acima de ${LIMITE_DISCO}%!"
    registrar_log "[ALERTA] Disco acima de ${LIMITE_DISCO}%: ${disco_uso}%"
  fi
}

# ------------------------------------------------------------
# Função: monitorar_apache
# Verifica se o Apache está em execução
# ------------------------------------------------------------
monitorar_apache() {
  if pgrep -x "apache2" > /dev/null; then
    echo "🌐 Apache: ✅ [OK] Em execução"
    registrar_log "[APACHE] Status: em execução"
  else
    echo "🌐 Apache: ❌ [ALERTA] Não está em execução!"
    registrar_log "[ALERTA] Apache não está em execução!"
    echo "   ↳ Execute: ./02_apache.sh para reiniciar."
  fi
}

# ------------------------------------------------------------
# Execução principal
# ------------------------------------------------------------
echo "============================================"
echo "  ShopCloud — Monitoramento do Sistema      "
echo "  Data/Hora: $(date '+%Y-%m-%d %H:%M:%S')  "
echo "============================================"
echo ""

registrar_log "=== INÍCIO DO MONITORAMENTO ==="

monitorar_cpu
echo ""
monitorar_memoria
echo ""
monitorar_disco
echo ""
monitorar_apache

registrar_log "=== FIM DO MONITORAMENTO ==="
echo ""
echo "📋 Log salvo em: $LOG_FILE"
echo "============================================"
