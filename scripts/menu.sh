#!/bin/bash
# ============================================================
# Script: menu.sh
# Descrição: Menu principal interativo do ShopCloud
# Projeto: ShopCloud - E-Commerce na Nuvem
# Aluno: Vitor Hugo Tavares | Unidavi
# ============================================================

SCRIPTS_DIR="/app/scripts"

# ------------------------------------------------------------
# Função: exibir_cabecalho
# ------------------------------------------------------------
exibir_cabecalho() {
  clear
  echo "============================================"
  echo "  Criado por : Vitor Hugo Tavares"
  echo "  Instituição: Unidavi — Sistemas de Informação"
  echo "  Tema       : E-Commerce na Nuvem (ShopCloud)"
  echo "============================================"
  echo "        MENU DEVOPS CLOUD — SHOPCLOUD       "
  echo "============================================"
  echo " 1 - Atualizar sistema"
  echo " 2 - Instalar e validar Apache"
  echo " 3 - Criar estrutura do projeto"
  echo " 4 - Realizar backup"
  echo " 5 - Fazer deploy do site"
  echo " 6 - Gerenciar processos"
  echo " 7 - Monitorar sistema"
  echo " 8 - Configurar usuários e permissões"
  echo " 9 - Gerar relatório operacional"
  echo " 0 - Sair"
  echo "============================================"
  echo -n " Escolha uma opção: "
}

# ------------------------------------------------------------
# Função: executar_script
# Executa o script correspondente à opção escolhida
# ------------------------------------------------------------
executar_script() {
  local script="$1"
  local descricao="$2"
  echo ""
  echo "▶️  Executando: $descricao"
  echo "--------------------------------------------"

  if [ -f "$SCRIPTS_DIR/$script" ]; then
    bash "$SCRIPTS_DIR/$script"
  else
    echo "❌ Script não encontrado: $SCRIPTS_DIR/$script"
  fi

  echo ""
  echo -n "Pressione [ENTER] para voltar ao menu..."
  read -r
}

# ------------------------------------------------------------
# Loop principal do menu
# ------------------------------------------------------------
while true; do
  exibir_cabecalho
  read -r opcao

  case "$opcao" in
    1) executar_script "01_update.sh" "Atualização do Sistema" ;;
    2) executar_script "02_apache.sh" "Instalação e Validação do Apache" ;;
    3) executar_script "03_estrutura.sh" "Criação da Estrutura de Diretórios" ;;
    4) executar_script "04_backup.sh" "Backup Automatizado" ;;
    5) executar_script "05_deploy.sh" "Deploy do Site ShopCloud" ;;
    6)
      clear
      echo "============================================"
      echo "  Gerenciamento de Processos"
      echo "============================================"
      echo " a - Listar processos"
      echo " b - Buscar processo por nome"
      echo " c - Encerrar processo por PID"
      echo "============================================"
      echo -n " Opção: "
      read -r subop
      case "$subop" in
        a) bash "$SCRIPTS_DIR/06_processos.sh" listar ;;
        b)
          echo -n "Nome do processo: "
          read -r nome
          bash "$SCRIPTS_DIR/06_processos.sh" buscar "$nome"
          ;;
        c)
          echo -n "PID do processo: "
          read -r pid
          bash "$SCRIPTS_DIR/06_processos.sh" matar "$pid"
          ;;
        *) echo "Opção inválida." ;;
      esac
      echo ""
      echo -n "Pressione [ENTER] para voltar ao menu..."
      read -r
      ;;
    7) executar_script "07_monitoramento.sh" "Monitoramento do Sistema" ;;
    8) executar_script "08_usuarios_permissoes.sh" "Configuração de Usuários e Permissões" ;;
    9) executar_script "09_relatorio.sh" "Relatório Operacional" ;;
    0)
      echo ""
      echo "👋 Saindo do ShopCloud DevOps Menu. Até logo!"
      echo ""
      exit 0
      ;;
    *)
      echo ""
      echo "❌ Opção inválida. Tente novamente."
      sleep 1
      ;;
  esac
done
