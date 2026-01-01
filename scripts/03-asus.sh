#!/bin/bash

echo "-------------------------------------------------"
echo "Instalando Herramientas ASUS ROG G16..."
echo "-------------------------------------------------"

# Instalar paquetes
yay -S --needed --noconfirm asusctl power-profiles-daemon rog-control-center envycontrol

# Habilitar servicios necesarios
echo "Habilitando servicios..."
sudo systemctl enable --now power-profiles-daemon
sudo systemctl enable --now asusd

# Nota: envycontrol no usa servicio systemd daemon, funciona bajo demanda, 
# pero rog-control-center necesita asusd.

echo "Herramientas Asus instaladas."