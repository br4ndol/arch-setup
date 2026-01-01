#!/bin/bash

echo "-------------------------------------------------"
echo "Instalando Drivers NVIDIA y Configurando Kernel..."
echo "-------------------------------------------------"

# Instalar paquetes (Aseguramos linux-zen base también por si acaso)
yay -S --needed --noconfirm linux-zen linux-zen-headers nvidia-dkms lib32-nvidia-utils libva-nvidia-driver egl-wayland

# Configurar MKINITCPIO
echo "Configurando módulos en mkinitcpio..."
# Usamos sed para reemplazar la línea de MODULES vacía o existente
sudo sed -i 's/^MODULES=(.*)/MODULES=(i915 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf

# Regenerar initramfs
sudo mkinitcpio -P

# Configurar GRUB
echo "Configurando parámetros del Kernel en GRUB..."
# Añade nvidia_drm.modeset=1 a la línea GRUB_CMDLINE_LINUX_DEFAULT si no existe
if ! grep -q "nvidia_drm.modeset=1" /etc/default/grub; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="nvidia_drm.modeset=1 /' /etc/default/grub
fi

# Regenerar configuración de GRUB (Usando tu ruta específica)
echo "Regenerando grub.cfg..."
if [ -d "/boot/efi/grub" ]; then
    sudo grub-mkconfig -o /boot/efi/grub/grub.cfg
else
    echo "ADVERTENCIA: La ruta /boot/efi/grub no existe. Usando ruta estándar /boot/grub/grub.cfg"
    sudo grub-mkconfig -o /boot/grub/grub.cfg
fi

# Verificación visual (opcional, solo imprime)
echo "Verificación de modeset (se aplicará tras reiniciar):"
echo "Comando futuro: sudo cat /sys/module/nvidia_drm/parameters/modeset"

# Nota sobre Hyprland
echo "NOTA: Las variables de entorno de Hyprland se configurarán cuando copies tus dotfiles."