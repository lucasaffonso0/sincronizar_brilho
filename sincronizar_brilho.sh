#!/bin/bash

# Identifica os monitores corretamente
NOTEBOOK_MONITOR=$(xrandr --query | grep " connected primary" | awk '{print $1}')
SEGUNDO_MONITOR=$(xrandr --query | grep " connected" | grep -v "primary" | awk '{print $1}')

# Verifica se os monitores foram encontrados
if [ -z "$NOTEBOOK_MONITOR" ] || [ -z "$SEGUNDO_MONITOR" ]; then
    echo "Erro: Não foi possível identificar os monitores corretamente."
    exit 1
fi

# Identifica o diretório correto do controle de brilho
BRILHO_DIR=$(ls /sys/class/backlight/ | head -n 1)
BRILHO_ATUAL="/sys/class/backlight/$BRILHO_DIR/brightness"
BRILHO_MAXIMO=$(cat /sys/class/backlight/$BRILHO_DIR/max_brightness)

# Verifica se o arquivo de brilho existe
if [ ! -f "$BRILHO_ATUAL" ]; then
    echo "Erro: Não foi possível acessar o controle de brilho do notebook."
    exit 1
fi

echo "Monitorando mudanças no brilho do notebook..."

# Monitora alterações no brilho do notebook e ajusta o segundo monitor automaticamente
while inotifywait -q -e modify "$BRILHO_ATUAL"; do
    # Obtém o novo brilho do notebook
    NOVO_BRILHO=$(cat "$BRILHO_ATUAL")

    # Converte para um valor entre 0 e 1
    BRILHO_NORMALIZADO=$(echo "scale=2; $NOVO_BRILHO / $BRILHO_MAXIMO" | bc)
    sleep 1
    # Ajusta o brilho do segundo monitor
    xrandr --output "$NOTEBOOK_MONITOR" --brightness "$BRILHO_NORMALIZADO"

    echo "Brilho sincronizado: $BRILHO_NORMALIZADO"
done