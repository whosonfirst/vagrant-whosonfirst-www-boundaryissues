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
sudo apt-get install -y git tcsh emacs24-nox htop sysstat ufw fail2ban unattended-upgrades python-setuptools unzip
sudo apt-get install -y gdal-bin
sudo apt-get install -y golang
sudo apt-get install -y make nginx gunicorn python-gevent python-flask
sudo apt-get install -y postgresql-9.3 postgresql-client postgis postgresql-9.3-postgis-scripts python-psycopg2
sudo apt-get install -y ruby-ronn

# https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-service.html

sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get install oracle-java8-installer -y

# https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-repositories.html

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/1.7/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-1.7.list
sudo apt-get update && sudo apt-get install elasticsearch
sudo update-rc.d elasticsearch defaults 95 10

# make sure postgres is set up incorrectly

echo "MAKING POSTGRES DESPERATELY INSECURE ON LOCALHOST"
sudo cp /etc/postgresql/9.3/main/pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf.bak
sudo perl -p -i -e 's/local\s+all\s+postgres\s+peer/local\tall\tpostgres\ttrust/' /etc/postgresql/9.3/main/pg_hba.conf

# see also:
# https://github.com/whosonfirst/whosonfirst-www-boundaryissues/blob/master/ubuntu/setup-postgres.sh

if sudo -u postgres psql -lqt | cut -d '|' -f 1 | grep -w whosonfirst; then
    echo "whosonfirst database already exists"
else
    sudo -u postgres createdb whosonfirst
    sudo -u postgres psql -d whosonfirst -c "CREATE EXTENSION postgis;"
    sudo -u postgres psql -d whosonfirst -c "CREATE EXTENSION postgis_topology;"
    sudo -u postgres psql -d whosonfirst -c "CREATE TABLE whosonfirst (id BIGINT PRIMARY KEY, parent_id BIGINT, placetype VARCHAR, properties TEXT, geom GEOGRAPHY(MULTIPOLYGON, 4326), centroid GEOGRAPHY(POINT, 4326));"
    sudo -u postgres psql -d whosonfirst -c "CREATE INDEX by_geom ON whosonfirst USING GIST(geom);"
    sudo -u postgres psql -d whosonfirst -c "CREATE INDEX by_placetype ON whosonfirst (placetype);"
    sudo -u postgres psql -d whosonfirst -c "VACUUM ANALYZE;"
fi

# make sure there is a config file for whosonfirst stuff

if [ -f /usr/local/mapzen/whosonfirst.cfg ]
then
   echo "whosonfirst config already exists"
else
   touch /usr/local/mapzen/whosonfirst.cfg
   chown vagrant.vagrant /usr/local/mapzen/whosonfirst.cfg
   chmod 600 /usr/local/mapzen/whosonfirst.cfg
   echo "[spatial]" >> /usr/local/mapzen/whosonfirst.cfg
   echo "db_user=postgres" >> /usr/local/mapzen/whosonfirst.cfg
   echo "db_pswd=" >> /usr/local/mapzen/whosonfirst.cfg
   echo "db_host=localhost" >> /usr/local/mapzen/whosonfirst.cfg
   echo "db_name=whosonfirst" >> /usr/local/mapzen/whosonfirst.cfg
   echo "" >> /usr/local/mapzen/whosonfirst.cfg
   echo "[search]" >> /usr/local/mapzen/whosonfirst.cfg
   echo "host=localhost" >> /usr/local/mapzen/whosonfirst.cfg
   echo "port=9200" >> /usr/local/mapzen/whosonfirst.cfg
fi

# make sure elasticsearch is running

if [ -f /var/run/elasticsearch/elasticsearch.pid ]
then 
     sudo /etc/init.d/elasticsearch start
     sleep 10
else

	# make sure elasticsearch is actually running...
	PID=`cat /var/run/elasticsearch/elasticsearch.pid`
	# ps -p ${PID}
fi

# mapzen/whosonfirst stuff

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

if [ ! -d /usr/local/mapzen/certified ]
then
    git clone https://github.com/rcrowley/certified.git /usr/local/mapzen/certified
    cd /usr/local/mapzen/certified
    sudo make install
    cd -
fi

# index all the data - this takes a while
# /usr/local/bin/wof-es-index -s /usr/local/mapzen/whosonfirst-data/data -b -v

# Setting up things from github:whosonfirst - see what's going on? basically configuring
# vagrant to do the right thing with ssh keys and stuff like github during the
# provisioning phase is a gigantic nuisance. So, we're just going to fake it for
# now and assume that it is possible to do all the usual GH stuff once you've 
# logged in... (20151008/thisisaaronland)

if [ ! -d /usr/local/mapzen/py-mapzen-whosonfirst-bundle ]
then

	git clone https://github.com/whosonfirst/py-mapzen-whosonfirst-bundle.git /usr/local/mapzen/py-mapzen-whosonfirst-bundle
	sudo chown -R vagrant.vagrant /usr/local/mapzen/py-mapzen-whosonfirst-bundle

	cd /usr/local/mapzen/py-mapzen-whosonfirst-bundle
	git remote rm origin
	git remote add origin git@github.com:whosonfirst/py-mapzen-whosonfirst-bundle.git

	sudo python ./setup.py install
	cd -
else
	cd /usr/local/mapzen/py-mapzen-whosonfirst-bundle
	sudo python ./setup.py install
	cd -
fi 

if [ ! -d /usr/local/mapzen/whosonfirst-www-boundaryissues ]
then
	# git clone git@github.com:whosonfirst/whosonfirst-www-boundaryissues.git /usr/local/mapzen/whosonfirst-www-boundaryissues
	git clone https://github.com/whosonfirst/whosonfirst-www-boundaryissues.git /usr/local/mapzen/whosonfirst-www-boundaryissues

	sudo chown -R vagrant.vagrant /usr/local/mapzen/whosonfirst-www-boundaryissues
	cd /usr/local/mapzen/whosonfirst-www-boundaryissues
	git remote rm origin
	git remote add origin git@github.com:whosonfirst/whosonfirst-www-boundaryissues.git
else
	cd /usr/local/mapzen/whosonfirst-www-boundaryissues

	# See above
	# git pull origin master
fi

# DO STUFF HERE

cd -	

  SHELL
end
