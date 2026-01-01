#!/bin/bash

echo "-------------------------------------------------"
echo "Configurando Arranque (Grub, Plymouth, Ly, OS-Prober)..."
echo "-------------------------------------------------"

# 1. Instalar Paquetes necesarios
# Nota: brightnessctl es útil para laptops
yay -S --needed --noconfirm ly brightnessctl os-prober plymouth

# 2. Configurar LY (Display Manager)
echo "Habilitando servicio Ly..."
# Deshabilitamos cualquier otro DM por si acaso (gdm, sddm, etc)
sudo systemctl disable --now gdm sddm lightdm 2>/dev/null
sudo systemctl enable ly.service

# 3. Configurar OS-PROBER
echo "Configurando OS-Prober para Dual Boot..."
# Habilitar os-prober en grub (descomentar la línea o agregarla)
if grep -q "^#GRUB_DISABLE_OS_PROBER=false" /etc/default/grub; then
    sudo sed -i 's/^#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
elif ! grep -q "GRUB_DISABLE_OS_PROBER=false" /etc/default/grub; then
    echo "GRUB_DISABLE_OS_PROBER=false" | sudo tee -a /etc/default/grub
fi

# 4. Configurar PLYMOUTH
echo "Configurando Plymouth (Splash Screen)..."

# A) Agregar el HOOK de plymouth en mkinitcpio.conf
# Buscamos la palabra 'udev' y le añadimos 'plymouth' justo después
if ! grep -q "plymouth" /etc/mkinitcpio.conf; then
    sudo sed -i 's/udev/udev plymouth/g' /etc/mkinitcpio.conf
fi

# B) Establecer tema BGRT (Logo del fabricante, ideal para Asus ROG)
# La opción -R regenera el initramfs automáticamente, matamos dos pájaros de un tiro
sudo plymouth-set-default-theme -R bgrt

# 5. Configuración FINAL de GRUB (Nvidia + Plymouth)
echo "Aplicando parámetros del Kernel en GRUB..."

# Aquí combinamos tus notas de Nvidia y Plymouth en una sola línea perfecta.
# Tu nota Nvidia: nvidia_drm.modeset=1
# Tu nota Plymouth: quiet splash plymouth.use-simpledrm
# Resultado combinado:
CMDLINE_TEXT='GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash nvidia_drm.modeset=1 plymouth.use-simpledrm"'

# Reemplazamos la línea completa para asegurar que esté todo
sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|${CMDLINE_TEXT}|" /etc/default/grub

# 6. Regenerar GRUB
echo "Regenerando configuración de GRUB..."
if [ -d "/boot/efi/grub" ]; then
    sudo grub-mkconfig -o /boot/efi/grub/grub.cfg
else
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

echo "Configuración de arranque completada."