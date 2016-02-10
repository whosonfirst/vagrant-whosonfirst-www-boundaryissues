# vagrant-whosonfirst-www-boundaryissues

Everything - all the data, all the indexing, all the search - you need to run
the Who's On First Boundary Issues editor locally.

This is a work in progress. It probably doesn't work yet. But if you want to
try it out, try this:

```
mkdir -p /usr/local/mapzen
cd /usr/local/mapzen
git clone https://github.com/whosonfirst/vagrant-whosonfirst-www-boundaryissues.git
cd vagrant-whosonfirst-www-boundaryissues
make build
```

After the VM gets provisioned, you'll get SSH'd in. Type the following:

```
cd /usr/local/mapzen/whosonfirst-www-boundaryissues
make setup
```

If you're planning to work on the code base, take a look at the "Note to
developers" in `Vagrantfile.developer-example`. To use that one:

```
cp Vagrantfile.developer-example Vagrantfile
vagrant up
vagrant ssh
```

## See also

* https://github.com/whosonfirst/whosonfirst-www-boundaryissues
* http://whosonfirst.mapzen.com/
