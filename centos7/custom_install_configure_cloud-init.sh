
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

# Install epel repo
# ----------------- 
# wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# rpm -ivh epel-release-latest-7.noarch.rpm

# Need six  >1.11 (qui vient avec pip3.6 qui vient avec python3.6)
# ----------------------------------------------------------------
cd /tmp
yum -y install https://centos7.iuscommunity.org/ius-release.rpm
yum -y install python36u python36u-pip
pip3.6 install --upgrade pip
pip3.6 install six

# Get cloud-init sources
# ----------------------
cd /tmp
git clone https://github.com/cloud-init/cloud-init.git
cd cloud-init
#git checkout 18.5

# Install cloud-init
# ------------------
pip3.6 install -r requirements.txt 
python3.6 setup.py build
python3.6 setup.py install --init-system systemd

cloud-init status  # is 'disabled' now
cd /tmp
rm -rf /tmp/cloud-init

# Enable services for reboot persistence
# --------------------------------------
systemctl daemon-reload
for svc in cloud-init-local.service cloud-init.service cloud-config.service cloud-final.service; do
   systemctl enable $svc
done


# CONFIGURE /etc/cloud/cloud.cfg
# ------------------------------
echo -e " \n \n "  >> /etc/cloud/cloud.cfg
echo "# ALEX CONF" >> /etc/cloud/cloud.cfg
echo "# ---------" >> /etc/cloud/cloud.cfg
# initial : datasource_list: [ NoCloud, ConfigDrive, OpenNebula, Azure, AltCloud, OVF, MAAS, GCE, OpenStack, CloudSigma, Ec2, CloudStack, None ]
echo "datasource_list: [ NoCloud, AltCloud, OVF, MAAS, GCE, OpenStack, CloudSigma, None ]" >> /etc/cloud/cloud.cfg
echo "disable_vmware_customization: false" >> /etc/cloud/cloud.cfg

sed -i -e '/disable_root: true/s/^/#/g'  /etc/cloud/cloud.cfg      # default: disable_root: true
echo "disable_root: false" >> /etc/cloud/cloud.cfg

sed -i -e '/ssh_pwauth:   0/s/^/#/g'  /etc/cloud/cloud.cfg         # default: ssh_pwauth:   0
echo "ssh_pwauth: yes" >> /etc/cloud/cloud.cfg

sed -i -e 's/     lock_passwd: True/     lock_passwd: false/g'  /etc/cloud/cloud.cfg    # default: lock_passwd: True





# Verification
# ------------
cloud-init init --local  #juste une verif, peu prendre du temps

rm -f /var/log/cloud-init.log
rm -f /var/log/cloud-init-output.log




# start services, certains peuvent prendre un peu de temps.....
# -------------------------------------------------------------
#systemctl start cloud-init-local.service
#systemctl start cloud-init.service
#systemctl start cloud-config.service
#systemctl start cloud-final.service




