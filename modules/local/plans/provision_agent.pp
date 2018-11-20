# An example plan to provision an agent and sign the certificate
plan local::provision_agent (
  TargetSpec $master,
  TargetSpec $nodes,
) {
    # TODO: Format output
    # TODO: Check that we are running as root.
    # TODO: Support windows
    run_plan(facts, nodes => $master)
    $master_certname = get_targets($master)[0].facts()['fqdn']
    get_targets($nodes).each |$target| {
      run_plan(facts, nodes => $target)
      if $target.facts()['aio_agent_version'] == undef {
        # TODO: Handle errors
        run_task('bootstrap::linux', $target, master => $master_certname)
        run_plan(facts, nodes => $target)
        $node_certname = get_targets($target)[0].facts()['fqdn']
        # TODO: Add logic for including pe_repo
        run_task('cert_sign', $master, allow_dns_alt_names => 'yes', agent_certnames => $node_certname )
      }
    }
}
