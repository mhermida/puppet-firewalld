require 'puppet'
require 'puppet/provider/firewalld'

Puppet::Type.type(:firewalld_direct_passthrough).provide(
  :firewalld_cmd,
  :parent => Puppet::Provider::Firewalld
) do
  desc "Interact with firewall-cmd"


  def exists?
    @passt_args ||= generate_raw
    output=execute_firewall_cmd(['--direct', '--query-passthrough', @passt_args], nil, true, false)
    output.include?('yes')
  end

  def create
    @passt_args ||= generate_raw
    execute_firewall_cmd(['--direct', '--add-passthrough', @passt_args], nil)
  end

  def destroy
    @passt_args ||= generate_raw
    execute_firewall_cmd(['--direct', '--remove-passthrough', @passt_args], nil)
  end

  def generate_raw
    passt = []
    passt << [
	    @resource[:inet_protocol],
	    @resource[:args]
    ]
  end

end
