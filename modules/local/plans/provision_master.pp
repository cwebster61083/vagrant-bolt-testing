# An example plan to install PE on a node
plan local::provision_master (
  String $version = '2018.1.5',
  TargetSpec $nodes,
) {
    run_plan(facts, nodes => $nodes)
    get_targets($nodes).each |$target| {
      $master_facts = get_targets($target)[0].facts()
      $osname = $master_facts['os']['name'].downcase
      $osversion = $master_facts['os']['release']['full']
      upload_file('local/pe.conf', '/tmp/pe.conf', $target)
      run_task('ref_arch_setup::download_pe_tarball', $target,
            url => "http://pe-releases.puppetlabs.lan/${$version}/puppet-enterprise-${version}-${osname}-${osversion}-amd64.tar.gz",
            destination => '/tmp/ref_arch_setup'
            )
      run_task('ref_arch_setup::install_pe', $target,
            pe_tarball_path => "/tmp/ref_arch_setup/puppet-enterprise-${version}-${osname}-${osversion}-amd64.tar.gz",
            pe_conf_path => '/tmp/pe.conf'
            )
    }
}
