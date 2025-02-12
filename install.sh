#!/bin/bash

# Verificar se o script está sendo executado como root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script precisa ser executado como root!"
    exit 1
fi

# Verificar se os arquivos estão presentes no mesmo diretório
SCRIPT_PATH="./sincronizar_brilho.sh"
SERVICE_PATH="./sincronizar_brilho.service"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Erro: O arquivo $SCRIPT_PATH não foi encontrado no diretório atual!"
    exit 1
fi

if [ ! -f "$SERVICE_PATH" ]; then
    echo "Erro: O arquivo $SERVICE_PATH não foi encontrado no diretório atual!"
    exit 1
fi

# Instalar dependências necessárias
echo "Instalando dependências necessárias..."
apt update
apt install -y x11-xserver-utils inotify-tools

# Verificar se a instalação foi bem-sucedida
if [ $? -ne 0 ]; then
    echo "Erro ao instalar dependências. Verifique sua conexão com a internet ou as fontes de pacotes."
    exit 1
fi

# Definir os caminhos para o destino
DEST_SCRIPT_PATH="/usr/local/bin/sincronizar_brilho.sh"
DEST_SERVICE_PATH="/etc/systemd/system/sincronizar_brilho.service"

# Copiar o script sincronizar_brilho.sh para o diretório correto
echo "Copiando o script de ajuste de brilho para $DEST_SCRIPT_PATH..."
cp "$SCRIPT_PATH" "$DEST_SCRIPT_PATH"

# Tornar o script executável
chmod +x "$DEST_SCRIPT_PATH"

# Copiar o arquivo do serviço systemd
echo "Copiando o arquivo do serviço systemd para $DEST_SERVICE_PATH..."
cp "$SERVICE_PATH" "$DEST_SERVICE_PATH"

# Habilitar e iniciar o serviço
echo "Habilitando e iniciando o serviço..."
systemctl daemon-reload
systemctl enable sincronizar_brilho.service
systemctl start sincronizar_brilho.service

# Verificar status do serviço
echo "Verificando o status do serviço..."
systemctl status sincronizar_brilho.service

echo "Instalação concluída! O serviço de sincronização de brilho foi configurado e iniciado."
