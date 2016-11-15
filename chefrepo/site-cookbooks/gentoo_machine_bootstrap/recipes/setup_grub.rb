fail 'TODO'

# GRUB_ENABLE_CRYPTODISK=y to /etc/default/grub
# GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda1:#{node[:system_disk][:mapper_name]}"
#
# EXECUTE (on chroot most probably)
# grub-mkconfig -o /boot/grub/grub.cfg
# grub-install /dev/sda
