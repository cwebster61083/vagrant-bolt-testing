# An example plan to clean an agent certificate
plan local::decom_agent (
  TargetSpec $master,
  TargetSpec $nodes,
) {
    get_targets($nodes).each |$target| {
      without_default_logging() || { run_plan(facts, nodes => $target, '_catch_errors' => true) }
        # If the node is already gone, guess what the hostname is based on the name of the targetspec
        $node_fqdn = get_targets($target)[0].facts()['fqdn']
        $node_certname = $node_fqdn ? {
          undef => $target.name,
          default => $node_fqdn,
        }
        unless $node_certname == undef {
          run_command(
            "/opt/puppetlabs/puppet/bin/puppet node purge ${node_certname}",
            $master,
            "Attempting to purge ${node_certname} from the master",
            '_catch_errors' => true
            )
        }
    }
}
