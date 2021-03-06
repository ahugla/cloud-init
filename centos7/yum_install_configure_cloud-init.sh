
# INSTALL ON A FRESH CENTOS
# --------------------------

# clean all (normalement seul 'rm /var/log/boot.log' est necessaire car fresh install)
# ------------------------------------------------------------------------------------
rm -f /var/log/boot.log
rm -f /var/log/cloud-init.log
rm -f /var/log/cloud-init-output.log
rm -f /var/log/vmware-network*.log
rm -rf /var/lib/cloud
rm -f /etc/sudoers.d/90-cloud-init-users

yum install -y cloud-init


# CONFIGURE /etc/cloud/cloud.cfg
# ------------------------------
echo -e " \n \n "  >> /etc/cloud/cloud.cfg
echo "# ALEX CONF" >> /etc/cloud/cloud.cfg
echo "# ---------" >> /etc/cloud/cloud.cfg
# initial : datasource_list: [ NoCloud, ConfigDrive, OpenNebula, Azure, AltCloud, OVF, MAAS, GCE, OpenStack, CloudSigma, Ec2, CloudStack, None ]
echo "datasource_list: [ NoCloud, AltCloud, OVF, MAAS, GCE, OpenStack, CloudSigma, None ]" >> /etc/cloud/cloud.cfg
echo "disable_vmware_customization: false" >> /etc/cloud/cloud.cfg

sed -i -e '/disable_root: 1/s/^/#/g'  /etc/cloud/cloud.cfg        # default: disable_root: 1
echo "disable_root: false" >> /etc/cloud/cloud.cfg

sed -i -e '/ssh_pwauth:   0/s/^/#/g'  /etc/cloud/cloud.cfg        # default: ssh_pwauth:   0
echo "ssh_pwauth: yes" >> /etc/cloud/cloud.cfg

sed -i -e 's/    lock_passwd: true/    lock_passwd: false/g'  /etc/cloud/cloud.cfg    # default:  lock_passwd: true




