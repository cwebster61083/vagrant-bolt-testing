Vagrant Bolt Testing
====================

A simple repo to test out [vagrant-bolt](https://github.com/jarretlavallee/vagrant-bolt) with some PE install tasks. This repo currently will deploy a monolithic PE infrastructure and a few agents.

Usage
-----

Before using this repo, please ensure you have the following installed.

* Bolt 1.5+
* Vagrant 2.2.0+
* `vagrant plugin install vagrant-bolt`
* `vagrant plugin install oscar`
* `vagrant plugin install vagrant-vmpooler`
* Ensure that the openstack shell environment variables are configured for use with platform9. See https://confluence.puppetlabs.com/display/SRE/Platform9+User+Guide#Platform9UserGuide-HowdoIaccesstheAPI?

To use this repo run the following commands.

~~~shell
git clone https://github.com/jarretlavallee/vagrant-bolt-testing.git
cd vagrant-bolt-testing
vagrant bolt puppetfile install
vagrant up master
vagrant up agent
~~~

This will install 3 nodes in openstack: a puppet master and 2 agents.

If you are looking to bring up a machine with VMpooler, please ensure to create a `~/.vmfloaty.yaml` with the correct authentication information. You can then use it as a provider.

~~~shell
vagrant up ubuntu --provider=vmpooler
~~~