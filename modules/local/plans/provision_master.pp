# An example plan to install PE on a node
plan local::provision_master (
  String $version = '2018.1.5',
  TargetSpec $nodes,
) {
    run_plan(facts, nodes => $nodes)
    get_targets($nodes).each |$target| {
      $master_facts = get_targets($target)[0].facts()
      $osname = $master_facts['os']['family'].downcase ? {
        'redhat' => 'el',
        'debian' => 'ubuntu',
        /(suse|sles)/   => 'sles',
      }
      $osversion = $osname ? {
        'ubuntu' => $master_facts['os']['release']['full'],
        default => $master_facts['os']['release']['major'],
      }
      $arch = $osname ? {/(ubuntu|debian)/ => "amd64", default => "x86_64"}
      upload_file('local/pe.conf', '/tmp/pe.conf', $target)
      run_task('ref_arch_setup::download_pe_tarball', $target,
            url => "http://pe-releases.puppetlabs.lan/${$version}/puppet-enterprise-${version}-${osname}-${osversion}-${arch}.tar.gz",
            destination => '/tmp/ref_arch_setup'
            )
      run_task('ref_arch_setup::install_pe', $target,
            pe_tarball_path => "/tmp/ref_arch_setup/puppet-enterprise-${version}-${osname}-${osversion}-${$arch}.tar.gz",
            pe_conf_path => '/tmp/pe.conf'
            )
    }
}
