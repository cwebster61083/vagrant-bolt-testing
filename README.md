Vagrant Bolt Testing
====================

A simple repo to test out [vagrant-bolt](https://github.com/jarretlavallee/vagrant-bolt) with some PE install tasks.

This repo contains a Vagrantfile and Puppetfile to do some basic installation tasks using the bolt plugin.

Usage
-----

Before using this repo, please ensure you have Bolt 1.0+, Vagrant 2.2.0+, and vagrant-bolt installed.

To use this repo run the following commands.

~~~
git clone https://github.com/jarretlavallee/vagrant-bolt-testing.git
cd vagrant-bolt-testing
bolt puppetfile install --boltdir .
vagrant up
~~~

This will install 2 nodes locally in virtualbox: a puppet master and an agent.
