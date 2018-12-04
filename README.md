Vagrant Bolt Testing
====================

A simple repo to test out [vagrant-bolt](https://github.com/jarretlavallee/vagrant-bolt) with some PE install tasks.

This repo contains a Vagrantfile and Puppetfile to do some basic installation tasks using the bolt plugin.

Usage
-----

Before using this repo, please ensure you have Bolt 1.0+, Vagrant 2.2.0+, and vagrant-bolt installed. This currently uses [vagrant-hosts](https://github.com/oscar-stack/vagrant-hosts), so please have that installed as well.

To use this repo run the following commands.

~~~shell
git clone https://github.com/jarretlavallee/vagrant-bolt-testing.git
cd vagrant-bolt-testing
vagrant bolt puppetfile install
vagrant up master
vagrant up agent
vagrant up windows
~~~

This will install 3 nodes in openstack: a puppet master and 2 agents.
