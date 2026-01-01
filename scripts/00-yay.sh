#!/bin/bash

echo "-------------------------------------------------"
echo "Instalando YAY (AUR Helper)..."
echo "-------------------------------------------------"

# Verificar si yay ya está instalado
if command -v yay &> /dev/null; then
    echo "Yay ya está instalado."
else
    # Instalar dependencias necesarias para compilar
    sudo pacman -S --needed --noconfirm git base-devel

    # Clonar e instalar yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
    echo "Yay instalado correctamente."
fi