#!/usr/bin/env bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NONE='\033[0m'

echo -e "${BLUE}### Iniciando instalación automática para Asus ROG G16... ###${NONE}"

chmod +x scripts/*.sh

./scripts/00-yay.sh
./scripts/01-repos.sh

#echo -e "${GREEN}Instalando paquetes generales desde packages/general.txt...${NC}"
#yay -S --needed --noconfirm - < packages/general.txt

echo -e "${GREEN}Fase 1 completada.${NC}"

./scripts/02-nvidia.sh
./scripts/03-asus.sh
./scripts/04-boot.sh

echo -e "${GREEN}=== BASE DEL SISTEMA INSTALADA ===${NC}"
echo "Por favor reinicia el sistema antes de continuar con la instalación de Hyprland/Dotfiles para cargar los drivers de Nvidia correctamente."