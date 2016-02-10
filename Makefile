brandnew:
	if test -f Vagrantfile; then cp Vagrantfile Vagrantfile.last; fi
	if test -d .vagrant; then rm -rf .vagrant; fi
	$(MAKE) build

build: setup up go

setup:
	if ! test -f Vagrantfile; then cp Vagrantfile.example Vagrantfile; fi

up:
	vagrant up

go:
	vagrant ssh

start:
	vagrant up
	vagrant ssh

stop:
	vagrant halt

rebuild:
	vagrant up --provision

update:
	vagrant box update
