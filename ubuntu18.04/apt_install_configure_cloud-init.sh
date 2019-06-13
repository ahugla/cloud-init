# INSTALL ON A FRESH UBUNTU
# --------------------------
# touch /etc/cloud/cloud-init.disabled   #fichier qui permet de desactiver le cloud-init au reboot


# cloud-init deja installé par defaut
# -----------------------------------
sudo apt-get install --only-upgrade cloud-init


# clean all (normalement seul 'rm /var/log/boot.log' est necessaire car fresh install)
# ------------------------------------------------------------------------------------
sudo -i 
rm -f /var/log/boot.log
rm -f /var/log/cloud-init.log
rm -f /var/log/cloud-init-output.log
rm -f /var/log/vmware-network*.log
rm -rf /var/lib/cloud
rm -f /etc/sudoers.d/90-cloud-init-users
exit




# CONFIGURE /etc/cloud/cloud.cfg
# ------------------------------
sudo -i

echo -e " \n \n "  >> /etc/cloud/cloud.cfg
echo "# ALEX CONF" >> /etc/cloud/cloud.cfg
echo "# ---------" >> /etc/cloud/cloud.cfg
# initial : datasource_list: [ NoCloud, ConfigDrive, OpenNebula, Azure, AltCloud, OVF, MAAS, GCE, OpenStack, CloudSigma, Ec2, CloudStack, None ]
echo "datasource_list: [ NoCloud, AltCloud, OVF, MAAS, GCE, OpenStack, CloudSigma, None ]" >> /etc/cloud/cloud.cfg
echo "disable_vmware_customization: false" >> /etc/cloud/cloud.cfg

sed -i -e '/disable_root: true/s/^/#/g'  /etc/cloud/cloud.cfg        # default: disable_root: true
echo "disable_root: false" >> /etc/cloud/cloud.cfg

#sed -i -e '/ssh_pwauth:   0/s/^/#/g'  /etc/cloud/cloud.cfg        # default: pas de ligne ssh_pwauth   
echo "ssh_pwauth: yes" >> /etc/cloud/cloud.cfg

sed -i -e 's/    lock_passwd: True/    lock_passwd: false/g'  /etc/cloud/cloud.cfg    # default:  lock_passwd: True


#Comment out this line in the /usr/lib/tmpfiles.d/tmp.conf file:   D /tmp 1777 root root -
sed -i -e '/tmp 1777 root root -/s/^/#/g' /usr/lib/tmpfiles.d/tmp.conf

# if you have open-vm-tools installed, Add this line “After=dbus.service” under [Unit] in /lib/systemd/system/open-vm-tools.service file
sed -i -e '/\[Unit\]/a After=dbus.service' /lib/systemd/system/open-vm-tools.service


rm -f /etc/cloud/cloud.cfg.d/50-curtin-networking.cfg 


#exit du sudo -i
exit


# COMMENT
# touch /etc/cloud/cloud-init.disabled   #fichier qui permet de desactiver le cloud-init au reboot


#LE FAIRE UNE FOIS ????

#rm -rf /var/lib/cloud/* 
#cloud-init init 		# cree /var/lib/cloud/
#cloud-init modules -m final	# execute user data et instance scripts