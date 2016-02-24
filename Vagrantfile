# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vm.define "vagrant-whosonfirst-www-boundaryissues"
  config.vm.hostname = "boundaryissues.whosonfirst"

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  config.ssh.insert_key = false
  config.ssh.forward_agent = true

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 8989
  config.vm.network "forwarded_port", guest: 443, host: 8990

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Sync your existing WOF data
  # ---------------------------
  # If you already have the GitHub repository checked out, you can sync your
  # existing folder into the guest VM.
  #config.vm.synced_folder "/usr/local/mapzen/whosonfirst-data/data", "/usr/local/mapzen/whosonfirst-data/data",
  #id: "whosonfirst-data",
  #  owner: "vagrant",
  #  group: "www-data",
  #  mount_options: ["dmode=775,fmode=664"]

  # Note to developers
  # ------------------
  # If you're planning to work on the Boundary Issues code using a non-console-
  # based editor (i.e., something that is *not* emacs or vim), you may want to
  # uncomment the following folder sync so you can work on running code from the
  # host environment (i.e. Sublime Text or Atom Editor). Then... (see below in
  # the provision section)
  #config.vm.synced_folder "/usr/local/mapzen/whosonfirst-www-boundaryissues", "/usr/local/mapzen/whosonfirst-www-boundaryissues"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
      vb.memory = "4096"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y git tcsh emacs24-nox htop sysstat ufw fail2ban unattended-upgrades python-dev python-setuptools unzip

if [ ! -d /usr/local/mapzen/ ]
then
  sudo mkdir /usr/local/mapzen/
  sudo chown -R vagrant.vagrant /usr/local/mapzen/
fi

if [ ! -d /usr/local/mapzen/whosonfirst-data/data/ ]
then
  sudo mkdir -p /usr/local/mapzen/whosonfirst-data/data/
  sudo mkdir -p /usr/local/mapzen/whosonfirst-data/meta/
  sudo chown -R vagrant.vagrant /usr/local/mapzen/whosonfirst-data/
fi

if [ ! -d /usr/local/mapzen/whosonfirst-www-boundaryissues ]
then
  git clone https://github.com/whosonfirst/whosonfirst-www-boundaryissues.git /usr/local/mapzen/whosonfirst-www-boundaryissues
  cd /usr/local/mapzen/whosonfirst-www-boundaryissues
  git fetch
  git checkout flamework
  git remote rm origin
  git remote add origin git@github.com:whosonfirst/whosonfirst-www-boundaryissues.git
  sudo chown -R vagrant.vagrant /usr/local/mapzen/whosonfirst-www-boundaryissues
  cd -
fi

if [ -L /usr/local/mapzen/whosonfirst-www-boundaryissues/www/data ]
then
  sudo rm /usr/local/mapzen/whosonfirst-www-boundaryissues/www/data
fi
ln -s /usr/local/mapzen/whosonfirst-data/data /usr/local/mapzen/whosonfirst-www-boundaryissues/www/data

# Note to developers
# ------------------
# ... if you enabled the synced_folder above, you'll want to uncomment the
# following:
#if [ ! -d /usr/local/mapzen/smarty/templates_c ]
#then
#  rm -rf /usr/local/mapzen/whosonfirst-www-boundaryissues/www/templates_c
#  mkdir -p /usr/local/mapzen/smarty/templates_c
#  chown www-data:www-data /usr/local/mapzen/smarty/templates_c
#  ln -s /usr/local/mapzen/smarty/templates_c /usr/local/mapzen/whosonfirst-www-boundaryissues/www/templates_c
#fi

echo "+---------------------------------------------------------+"
echo "|                                                         |"
echo "|   Thank you for installing Boundary Issues.             |"
echo "|                                                         |"
echo "|   vagrant ssh                                           |"
echo "|   cd /usr/local/mapzen/whosonfirst-www-boundaryissues   |"
echo "|   make setup                                            |"
echo "|                                                         |"
echo "|   https://localhost:8990/                               |"
echo "|                                                         |"
echo "+---------------------------------------------------------+"

  SHELL
end
