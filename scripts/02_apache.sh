#!/bin/bash
# ============================================================
# Script: 02_apache.sh
# Descrição: Instala, inicia e valida o Apache para o ShopCloud
# Projeto: ShopCloud - E-Commerce na Nuvem
# Aluno: Vitor Hugo Tavares | Unidavi
# ============================================================

LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/apache.log"

mkdir -p "$LOG_DIR"

# ------------------------------------------------------------
# Função: registrar_log
# ------------------------------------------------------------
registrar_log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ------------------------------------------------------------
# Função: instalar_apache
# Instala o Apache2 e o curl (usado para testes HTTP)
# ------------------------------------------------------------
instalar_apache() {
  echo "📦 Verificando se o Apache já está instalado..."

  if command -v apache2 &> /dev/null; then
    registrar_log "[OK] Apache já está instalado. Pulando instalação."
    echo "✅ Apache já instalado."
  else
    registrar_log "[INFO] Apache não encontrado. Iniciando instalação..."
    echo "⬇️  Instalando Apache2..."

    apt-get update -y >> "$LOG_FILE" 2>&1
    if apt-get install -y apache2 >> "$LOG_FILE" 2>&1; then
      registrar_log "[OK] Apache2 instalado com sucesso."
      echo "✅ Apache2 instalado."
    else
      registrar_log "[ERRO] Falha na instalação do Apache2."
      echo "❌ Erro ao instalar Apache2."
      exit 1
    fi
  fi
}

# ------------------------------------------------------------
# Função: verificar_apache
# Verifica se o processo do Apache está em execução
# ------------------------------------------------------------
verificar_apache() {
  echo ""
  echo "🔍 Verificando status do Apache..."

  # Tenta iniciar o Apache (necessário em containers, onde systemctl não funciona)
  service apache2 start >> "$LOG_FILE" 2>&1

  # Verifica se o processo apache2 está rodando
  if pgrep -x "apache2" > /dev/null; then
    registrar_log "[OK] Apache está em execução."
    echo "✅ Apache está em execução."
  else
    registrar_log "[ALERTA] Apache não está em execução."
    echo "⚠️  Apache não está em execução. Tentando iniciar..."
    service apache2 start
    if pgrep -x "apache2" > /dev/null; then
      registrar_log "[OK] Apache iniciado com sucesso."
      echo "✅ Apache iniciado."
    else
      registrar_log "[ERRO] Não foi possível iniciar o Apache."
      echo "❌ Falha ao iniciar o Apache."
    fi
  fi
}

# ------------------------------------------------------------
# Função: versao_apache
# Exibe a versão instalada do Apache
# ------------------------------------------------------------
versao_apache() {
  echo ""
  echo "ℹ️  Versão do Apache instalada:"
  local versao
  versao=$(apache2 -v 2>/dev/null | head -1)
  echo "   $versao"
  registrar_log "[INFO] Versão: $versao"
}

# ------------------------------------------------------------
# Execução principal
# ------------------------------------------------------------
echo "============================================"
echo "  ShopCloud — Instalação e Validação Apache "
echo "============================================"
instalar_apache
verificar_apache
versao_apache
echo ""
echo "📋 Log salvo em: $LOG_FILE"
echo "============================================"
