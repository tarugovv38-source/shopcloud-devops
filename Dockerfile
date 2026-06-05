# Imagem base Ubuntu Server
FROM ubuntu:22.04

# Evita prompts interativos durante instalação de pacotes
ENV DEBIAN_FRONTEND=noninteractive

# Atualiza repositórios e instala dependências básicas
RUN apt-get update && apt-get install -y \
    apache2 \
    curl \
    vim \
    procps \
    net-tools \
    tar \
    gzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Cria a estrutura base do projeto dentro do container
RUN mkdir -p /app/ecommerce/{produtos,pedidos,clientes,logs,backups,publicacao}

# Copia os scripts para dentro do container
COPY scripts/ /app/scripts/

# Copia os arquivos do site estático
COPY source/ /app/source/

# Copia pastas de logs e backups (podem estar vazias inicialmente)
COPY logs/ /app/logs/
COPY backups/ /app/backups/

# Garante permissão de execução em todos os scripts
RUN chmod +x /app/scripts/*.sh

# Expõe a porta 80 do Apache
EXPOSE 80

# Mantém o container rodando e inicia o Apache
CMD ["bash", "-c", "service apache2 start && tail -f /dev/null"]
