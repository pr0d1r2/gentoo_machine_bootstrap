# See: http://www.asrockrack.com/general/productdetail.asp?Model=C2750D4I#Specifications

# Intel i210
kernel_enable 'CONFIG_NETDEV_1000'
kernel_enable 'CONFIG_NET_VENDOR_INTEL'
kernel_enable 'CONFIG_IGB'
kernel_enable 'CONFIG_IGB_DCA'
kernel_enable 'CONFIG_IGB_HWMON'

# Marvell SE9172 & SE9230
kernel_enable 'CONFIG_SATA_MV'
