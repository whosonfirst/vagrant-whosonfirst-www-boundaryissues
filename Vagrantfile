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

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "/usr/local/mapzen/whosonfirst-data", "/usr/local/mapzen/whosonfirst-data"
  # config.vm.synced_folder "/usr/local/mapzen/whosonfirst-venue", "/usr/local/mapzen/whosonfirst-venue"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
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
sudo apt-get install -y git tcsh emacs24-nox htop sysstat ufw fail2ban unattended-upgrades python-setuptools unzip
sudo apt-get install -y make nginx gunicorn python-gevent python-flask
sudo apt-get install postgresql-client-common postgresql-client-9.3 python-psycopg2 
# setup repositories for oracle8 and elasticsearch
# sudo apt-get install -y oracle-java8-installer elasticsearch

if [ ! -d /usr/local/mapzen ]
then
    sudo mkdir /usr/local/mapzen
fi

sudo chown vagrant /usr/local/mapzen

if [ ! -d /usr/local/mapzen/lockedbox ]
then
    sudo mkdir /usr/local/mapzen/lockedbox
    sudo chown root /usr/local/mapzen/lockedbox
    sudo chmod 700 /usr/local/mapzen/lockedbox
fi

if [ ! -d /usr/local/mapzen/certified]
then
    git clone https://github.com/rcrowley/certified.git /usr/local/mapzen/certified
    cd /usr/local/mapzen/certified
    sudo apt-get install -y ruby-ronn
    sudo make install
    cd -

    certified-ca C="US" ST="CA" L="San Francisco" O="Whosonfirst" CN="Whosonfirst Boundary Issues CA"
fi

if [ ! -f /usr/local/mapzen/lockedbox/wof-boundaryissues.key ]
then

    if [ ! -f /usr/local/mapzen/lockedbox/wof-boundaryissues-key-crt.txt ]
	PUBLIC_IP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
	sudo certified CN="localhost" +"${PUBLIC_IP}" > /usr/local/mapzen/lockedbox/wof-boundaryissues-key-crt.txt
    fi

    sudo chown root /usr/local/mapzen/lockedbox/wof-boundaryissues-key-crt.txt
    sudo chmod 600 /usr/local/mapzen/lockedbox/wof-boundaryissues-key-crt.txt

    echo "wof-boundaryissues key and cert have been generated but you still need to install them separately yourself"
fi
     
# git@github.com:mapzen/py-mapzen-whosonfirst-spatial.git
# git@github.com:mapzen/py-mapzen-whosonfirst-search.git

if [ ! -d /usr/local/mapzen/whosonfirst-www-boundaryissues ]
then
	cd 
	git@github.com:mapzen/whosonfirst-www-boundaryissues.git /usr/local/mapzen/whosonfirst-www-boundaryissues
	cd /usr/local/mapzen/whosonfirst-www-boundaryissues
	# install me...
	cd -
else
	cd /usr/local/mapzen/whosonfirst-www-boundaryissues
	git pull origin master
	# re-install me?
	cd -	
fi

if [ ! -d /usr/local/mapzen/whosonfirst-data ]
then
	git clone git@github.com:mapzen/whosonfirst-data.git /usr/local/mapzen/whosonfirst-data
else
	cd /usr/local/mapzen/whosonfirst-data
	git pull origin master
	cd -
fi

# index the data...

# (re)start all the servers

  SHELL
end
