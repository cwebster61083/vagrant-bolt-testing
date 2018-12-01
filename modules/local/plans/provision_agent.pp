# An example plan to provision an agent and sign the certificate
plan local::provision_agent (
  TargetSpec $master,
  TargetSpec $nodes,
) {
    # TODO: Format output
    # TODO: Check that we are running as root/Administrator.
    # TODO: Handle errors

    notice('Updating facts for nodes')
    without_default_logging() || { run_plan(facts, nodes => $nodes) }
    get_targets($nodes).each |$target| {
      $target_facts = $target.facts()
      if $target_facts['platform_tag'] == undef {
        # Update Master facts if needed
        if get_targets($master)[0].facts()['fqdn'] == undef {
          notice("Updating facts for ${master}")
          without_default_logging() || { run_plan(facts, nodes => $master) }
        }
        $master_fqdn = get_targets($master)[0].facts()['fqdn']
        if $master_fqdn == undef {
          fail_plan("Unable to get Master FQDN while bootstrapping ${target.name}. Is it online and configured?")
        }

        $bootstrap_task = $target_facts['os']['family'].downcase ? {
          'windows' => 'bootstrap::windows',
          default => 'bootstrap::linux'
        }
        $platform = local::platform_tag($target_facts, true)
        run_command(
          "/opt/puppetlabs/puppet/bin/puppet apply -e \"include pe_repo::platform::${platform}\"",
          $master,
          "Ensuring ${platform} agent packages are available on ${master_fqdn}",
        )
        run_task(
          $bootstrap_task,
          $target,
          master => $master_fqdn
        )
        without_default_logging() || { run_plan(facts, nodes => $target) }
        $node_fqdn = get_targets($target)[0].facts()['fqdn']
        run_task(
          'cert_sign',
          $master,
          "Signing certificate for ${node_fqdn} on ${master_fqdn}",
          allow_dns_alt_names => 'yes',
          agent_certnames => $node_fqdn
        )
      } else {
        notice('Already Bootstrapped')
      }
    }
}
