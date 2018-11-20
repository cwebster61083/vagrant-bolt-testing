# An example plan to clean an agent certificate
plan local::decom_agent (
  TargetSpec $master,
  TargetSpec $nodes,
) {
    get_targets($nodes).each |$target| {
      run_plan(facts, nodes => $target, '_catch_errors' => true)
        $node_certname = get_targets($target)[0].facts()['fqdn']
        unless $node_certname == undef {
          run_command("/opt/puppetlabs/puppet/bin/puppet node purge ${node_certname}", $master, '_catch_errors' => true)
        }
    }
}
