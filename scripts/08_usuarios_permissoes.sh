#!/bin/bash
# ============================================================
# Script: 08_usuarios_permissoes.sh
# Descrição: Cria usuários, grupos e define permissões no ShopCloud
# Projeto: ShopCloud - E-Commerce na Nuvem
# Aluno: Vitor Hugo Tavares | Unidavi
# ============================================================

LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/usuarios.log"
BASE_DIR="/app/ecommerce"

mkdir -p "$LOG_DIR"

# ------------------------------------------------------------
# Função: registrar_log
# ------------------------------------------------------------
registrar_log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ------------------------------------------------------------
# Função: criar_grupos
# Cria os grupos do e-commerce (operação e leitura)
# ------------------------------------------------------------
criar_grupos() {
  echo "👥 Criando grupos do ShopCloud..."

  local grupos=("ecommerce_ops" "ecommerce_leitura")

  for grupo in "${grupos[@]}"; do
    if getent group "$grupo" > /dev/null 2>&1; then
      echo "   ℹ️  Grupo '$grupo' já existe."
      registrar_log "[INFO] Grupo '$grupo' já existe."
    else
      groupadd "$grupo"
      registrar_log "[OK] Grupo '$grupo' criado."
      echo "   ✅ Grupo '$grupo' criado."
    fi
  done
}

# ------------------------------------------------------------
# Função: criar_usuarios
# Cria usuários de sistema relacionados ao e-commerce
# ------------------------------------------------------------
criar_usuarios() {
  echo ""
  echo "👤 Criando usuários do ShopCloud..."

  # pedido_user: responsável pelo módulo de pedidos
  if id "pedido_user" &>/dev/null; then
    echo "   ℹ️  Usuário 'pedido_user' já existe."
    registrar_log "[INFO] Usuário 'pedido_user' já existe."
  else
    useradd -r -s /usr/sbin/nologin -G ecommerce_ops -c "Usuário de Pedidos ShopCloud" pedido_user
    registrar_log "[OK] Usuário 'pedido_user' criado no grupo 'ecommerce_ops'."
    echo "   ✅ Usuário 'pedido_user' criado."
  fi

  # estoque_user: responsável pelo módulo de estoque (somente leitura)
  if id "estoque_user" &>/dev/null; then
    echo "   ℹ️  Usuário 'estoque_user' já existe."
    registrar_log "[INFO] Usuário 'estoque_user' já existe."
  else
    useradd -r -s /usr/sbin/nologin -G ecommerce_leitura -c "Usuário de Estoque ShopCloud" estoque_user
    registrar_log "[OK] Usuário 'estoque_user' criado no grupo 'ecommerce_leitura'."
    echo "   ✅ Usuário 'estoque_user' criado."
  fi
}

# ------------------------------------------------------------
# Função: aplicar_permissoes
# Aplica chown e chmod nos diretórios do e-commerce
# Evita permissões excessivamente abertas como 777
# ------------------------------------------------------------
aplicar_permissoes() {
  echo ""
  echo "🔐 Aplicando permissões nos diretórios..."

  # Verifica se a estrutura existe
  if [ ! -d "$BASE_DIR" ]; then
    echo "   ⚠️  Estrutura não encontrada. Execute primeiro o 03_estrutura.sh"
    registrar_log "[AVISO] Diretório $BASE_DIR não existe."
    return
  fi

  # Pedidos: dono pedido_user, grupo ecommerce_ops, leitura/escrita para dono e grupo
  if id "pedido_user" &>/dev/null; then
    chown -R pedido_user:ecommerce_ops "$BASE_DIR/pedidos"
    chmod 770 "$BASE_DIR/pedidos"   # dono e grupo têm rwx, outros sem acesso
    registrar_log "[OK] Permissão 770 aplicada em $BASE_DIR/pedidos (pedido_user:ecommerce_ops)"
    echo "   ✅ $BASE_DIR/pedidos → 770 (pedido_user:ecommerce_ops)"
  fi

  # Estoque: dono estoque_user, grupo ecommerce_leitura, somente leitura para grupo
  if id "estoque_user" &>/dev/null; then
    chown -R estoque_user:ecommerce_leitura "$BASE_DIR/estoque"
    chmod 750 "$BASE_DIR/estoque"   # dono rwx, grupo r-x, outros sem acesso
    registrar_log "[OK] Permissão 750 aplicada em $BASE_DIR/estoque (estoque_user:ecommerce_leitura)"
    echo "   ✅ $BASE_DIR/estoque → 750 (estoque_user:ecommerce_leitura)"
  fi

  # Logs: somente root lê/escreve, grupo ecommerce_ops apenas lê
  chown -R root:ecommerce_ops "$BASE_DIR/logs"
  chmod 750 "$BASE_DIR/logs"
  registrar_log "[OK] Permissão 750 aplicada em $BASE_DIR/logs"
  echo "   ✅ $BASE_DIR/logs → 750 (root:ecommerce_ops)"

  # Clientes: permissão restritiva (dados sensíveis)
  chown -R root:ecommerce_ops "$BASE_DIR/clientes"
  chmod 700 "$BASE_DIR/clientes"   # somente root acessa dados de clientes
  registrar_log "[OK] Permissão 700 aplicada em $BASE_DIR/clientes (dados sensíveis)"
  echo "   ✅ $BASE_DIR/clientes → 700 (root — dados sensíveis)"
}

# ------------------------------------------------------------
# Função: exibir_resumo
# Exibe usuários criados e permissões aplicadas
# ------------------------------------------------------------
exibir_resumo() {
  echo ""
  echo "📋 Resumo de usuários e grupos:"
  echo "--------------------------------------------"
  echo "Grupos:"
  getent group ecommerce_ops ecommerce_leitura 2>/dev/null
  echo ""
  echo "Usuários:"
  id pedido_user 2>/dev/null || echo "   pedido_user não encontrado"
  id estoque_user 2>/dev/null || echo "   estoque_user não encontrado"
  echo ""
  echo "Permissões:"
  ls -ld "$BASE_DIR"/pedidos "$BASE_DIR"/estoque "$BASE_DIR"/logs "$BASE_DIR"/clientes 2>/dev/null
}

# ------------------------------------------------------------
# Execução principal
# ------------------------------------------------------------
echo "============================================"
echo "  ShopCloud — Usuários e Permissões         "
echo "============================================"
criar_grupos
criar_usuarios
aplicar_permissoes
exibir_resumo
registrar_log "=== CONFIGURAÇÃO DE USUÁRIOS E PERMISSÕES CONCLUÍDA ==="
echo ""
echo "📋 Log salvo em: $LOG_FILE"
echo "============================================"
