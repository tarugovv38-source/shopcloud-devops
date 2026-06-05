#!/bin/bash
# ============================================================
# Script: 05_deploy.sh
# Descrição: Publica os arquivos do ShopCloud no Apache
# Projeto: ShopCloud - E-Commerce na Nuvem
# Aluno: Vitor Hugo Tavares | Unidavi
# ============================================================

ORIGEM="/app/source"
DESTINO="/var/www/html"
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/deploy.log"

mkdir -p "$LOG_DIR"

# ------------------------------------------------------------
# Função: registrar_log
# ------------------------------------------------------------
registrar_log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ------------------------------------------------------------
# Função: verificar_source
# Valida se a pasta source/ com os arquivos do site existe
# ------------------------------------------------------------
verificar_source() {
  if [ ! -d "$ORIGEM" ]; then
    registrar_log "[ERRO] Diretório source/ não encontrado: $ORIGEM"
    echo "❌ Pasta $ORIGEM não existe."
    exit 1
  fi

  if [ ! -f "$ORIGEM/index.html" ]; then
    registrar_log "[ERRO] index.html não encontrado em $ORIGEM"
    echo "❌ index.html não encontrado na pasta source/."
    exit 1
  fi

  registrar_log "[OK] Diretório source/ verificado."
  echo "✅ Arquivos fonte encontrados."
}

# ------------------------------------------------------------
# Função: limpar_destino
# Remove os arquivos antigos do Apache antes do novo deploy
# ------------------------------------------------------------
limpar_destino() {
  echo ""
  echo "🗑️  Limpando diretório de destino: $DESTINO"
  rm -rf "${DESTINO:?}"/*
  registrar_log "[OK] Diretório $DESTINO limpo."
  echo "✅ Destino limpo."
}

# ------------------------------------------------------------
# Função: realizar_deploy
# Copia os arquivos do site para o diretório do Apache
# ------------------------------------------------------------
realizar_deploy() {
  echo ""
  echo "🚀 Realizando deploy do ShopCloud para $DESTINO..."

  if cp -r "$ORIGEM"/. "$DESTINO/"; then
    registrar_log "[OK] Arquivos copiados de $ORIGEM para $DESTINO"
    echo "✅ Deploy realizado com sucesso."
  else
    registrar_log "[ERRO] Falha ao copiar arquivos."
    echo "❌ Erro durante o deploy."
    exit 1
  fi
}

# ------------------------------------------------------------
# Função: validar_deploy
# Verifica se o index.html chegou corretamente ao destino
# ------------------------------------------------------------
validar_deploy() {
  echo ""
  echo "🔍 Validando deploy..."

  if [ -f "$DESTINO/index.html" ]; then
    registrar_log "[OK] index.html confirmado em $DESTINO"
    echo "✅ index.html publicado com sucesso."
  else
    registrar_log "[ERRO] index.html não encontrado em $DESTINO após deploy."
    echo "❌ Deploy inválido: index.html não encontrado."
    exit 1
  fi

  echo ""
  echo "📂 Arquivos publicados em $DESTINO:"
  ls -lh "$DESTINO"
}

# ------------------------------------------------------------
# Execução principal
# ------------------------------------------------------------
echo "============================================"
echo "  ShopCloud — Deploy do Site Estático       "
echo "============================================"
verificar_source
limpar_destino
realizar_deploy
validar_deploy
registrar_log "=== DEPLOY CONCLUÍDO ==="
echo ""
echo "🌐 Acesse: http://localhost:8080"
echo "📋 Log salvo em: $LOG_FILE"
echo "============================================"
