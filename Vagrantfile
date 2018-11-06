require 'vagrant-bolt'
Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.ssh.insert_key = false
  config.bolt.run_as = 'root'

  # Configure the local hosts file
  # config.trigger.after :up, destroy do |trigger|
  #   trigger.name = 'Updating Hosts'
  #   trigger.ruby do |env, machine|
  #     VagrantBolt.plan('hosts', env, machine, nodes: 'ALL')
  #   end
  # end
  # config.trigger.before :provision do |trigger|
  #   trigger.name = 'Updating Hosts'
  #   trigger.ruby do |env, machine|
  #     VagrantBolt.plan('hosts', env, machine, nodes: 'ALL')
  #   end
  # end

  config.vm.define :master do |node|
    node.vm.hostname = 'master.delivery.puppetlabs.net'
    node.vm.provider 'virtualbox' do |v|
      v.memory = 6000
      v.cpus = 4
    end
    node.vm.network :private_network, ip: '172.16.10.10'
    node.vm.provision 'file', source: 'pe.conf', destination: '/tmp/pe.conf'
    node.vm.provision :hosts do |provisioner|
      provisioner.sync_hosts = true
      provisioner.imports = ['virtualbox']
      provisioner.exports = {
        'virtualbox' => [
          ['@vagrant_private_networks', ['@vagrant_hostnames']],
        ],
      }
    end
    node.vm.provision :bolt do |bolt|
      bolt.type       = :task
      bolt.name       = 'ref_arch_setup::download_pe_tarball'
      bolt.parameters = {
        'url' => 'http://pe-releases.puppetlabs.lan/2018.1.4/puppet-enterprise-2018.1.4-ubuntu-16.04-amd64.tar.gz',
        'destination' => '/tmp/ref_arch_setup',
      }
    end
    node.vm.provision :bolt do |bolt|
      bolt.type       = :task
      bolt.name       = 'ref_arch_setup::install_pe'
      bolt.parameters = {
        'pe_tarball_path' => '/tmp/ref_arch_setup/puppet-enterprise-2018.1.4-ubuntu-16.04-amd64.tar.gz',
        'pe_conf_path'    => '/tmp/pe.conf',
      }
    end
  end

  config.vm.define :agent do |node|
    node.vm.hostname = 'agent.delivery.puppetlabs.net'
    node.bolt.dependencies = [:master]
    node.vm.network :private_network, ip: '172.16.10.11'
    node.vm.provision :hosts do |provisioner|
      provisioner.sync_hosts = true
      provisioner.imports = ['virtualbox']
      provisioner.exports = {
        'virtualbox' => [
          ['@vagrant_private_networks', ['@vagrant_hostnames']],
        ],
      }
    end
    node.vm.provision :bolt do |bolt|
      bolt.type       = :task
      bolt.name       = 'bootstrap::linux'
      bolt.parameters = {
        'master' => 'master.delivery.puppetlabs.net',
      }
    end
    node.vm.provision :bolt do |bolt|
      bolt.type  = :task
      bolt.name  = 'cert_sign'
      bolt.nodes = [:master]
      bolt.parameters = {
        'agent_certnames' => 'agent.delivery.puppetlabs.net',
        'allow_dns_alt_names' => 'yes',
      }
    end
  end
end
