#!/bin/bash
# ============================================================
# Script: 03_estrutura.sh
# Descrição: Cria a estrutura de diretórios do ShopCloud
# Projeto: ShopCloud - E-Commerce na Nuvem
# Aluno: Vitor Hugo Tavares | Unidavi
# ============================================================

LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/estrutura.log"
BASE_DIR="/app/ecommerce"

mkdir -p "$LOG_DIR"

# ------------------------------------------------------------
# Função: registrar_log
# ------------------------------------------------------------
registrar_log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ------------------------------------------------------------
# Função: remover_estrutura_antiga
# Remove a estrutura anterior com segurança
# ------------------------------------------------------------
remover_estrutura_antiga() {
  if [ -d "$BASE_DIR" ]; then
    echo "🗑️  Removendo estrutura antiga em $BASE_DIR..."
    rm -rf "$BASE_DIR"
    registrar_log "[INFO] Estrutura antiga removida."
  fi
}

# ------------------------------------------------------------
# Função: criar_estrutura
# Cria os diretórios do e-commerce com subpastas temáticas
# ------------------------------------------------------------
criar_estrutura() {
  echo "📁 Criando estrutura de diretórios do ShopCloud..."

  # Diretórios principais do e-commerce
  local diretorios=(
    "$BASE_DIR/produtos"
    "$BASE_DIR/pedidos"
    "$BASE_DIR/clientes"
    "$BASE_DIR/pagamentos"
    "$BASE_DIR/estoque"
    "$BASE_DIR/publicacao"
    "$BASE_DIR/logs"
    "$BASE_DIR/backups"
  )

  for dir in "${diretorios[@]}"; do
    mkdir -p "$dir"
    registrar_log "[OK] Criado: $dir"
    echo "   ✅ $dir"
  done
}

# ------------------------------------------------------------
# Função: criar_arquivos_iniciais
# Cria arquivos placeholder em cada diretório
# ------------------------------------------------------------
criar_arquivos_iniciais() {
  echo ""
  echo "📄 Criando arquivos iniciais..."

  # Arquivo de catálogo inicial de produtos
  echo "# Catálogo de Produtos - ShopCloud" > "$BASE_DIR/produtos/catalogo.txt"
  echo "Criado em: $(date)" >> "$BASE_DIR/produtos/catalogo.txt"

  # Arquivo de controle de pedidos
  echo "# Registro de Pedidos - ShopCloud" > "$BASE_DIR/pedidos/pedidos.txt"
  echo "Criado em: $(date)" >> "$BASE_DIR/pedidos/pedidos.txt"

  # Arquivo de clientes cadastrados
  echo "# Base de Clientes - ShopCloud" > "$BASE_DIR/clientes/clientes.txt"
  echo "Criado em: $(date)" >> "$BASE_DIR/clientes/clientes.txt"

  # Arquivo de controle de estoque
  echo "# Controle de Estoque - ShopCloud" > "$BASE_DIR/estoque/estoque.txt"
  echo "Criado em: $(date)" >> "$BASE_DIR/estoque/estoque.txt"

  registrar_log "[OK] Arquivos iniciais criados."
  echo "   ✅ Arquivos placeholder criados."
}

# ------------------------------------------------------------
# Função: exibir_arvore
# Lista a estrutura criada no terminal
# ------------------------------------------------------------
exibir_arvore() {
  echo ""
  echo "📂 Estrutura criada:"
  find "$BASE_DIR" | sed 's|[^/]*/|   |g'
}

# ------------------------------------------------------------
# Execução principal
# ------------------------------------------------------------
echo "============================================"
echo "  ShopCloud — Estrutura de Diretórios       "
echo "============================================"
remover_estrutura_antiga
criar_estrutura
criar_arquivos_iniciais
exibir_arvore
registrar_log "=== ESTRUTURA CRIADA COM SUCESSO ==="
echo ""
echo "📋 Log salvo em: $LOG_FILE"
echo "============================================"
