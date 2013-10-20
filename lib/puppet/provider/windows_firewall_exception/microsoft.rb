require 'puppet/type'

#TODO: add support for windows xp + server 2003
Puppet::Type.type(:windows_firewall_exception).provide(:microsoft) do

  defaultfor :operatingsystem => :windows
  confine    :operatingsystem => :windows

  commands :netsh => 'C:\\Windows\\System32\\netsh.exe'

  def self.instances
    []
  end

  def exists?
    Puppet.debug("Checking the existence of firewall exception value: #{self}")
    args = ["advfirewall", "firewall", "show", "rule", "name=\"#{resource[:name]}\""]
    exists = false
    begin
      check = netsh args
      exists = check.zero?
    rescue
      #netsh returns "No rules match specified criteria" with exit code 1
      exists = false
    end

    exists
  end

  def create
    Puppet.debug("Creating firewall exception: #{self}")
    netsh gen_args
  end

  def destroy
    Puppet.debug("Destroying firewall exception: #{self}")
    netsh gen_args
  end

  def gen_args

    if resource[:ensure] == :absent
      fw_action = 'delete'
    else
      fw_action = 'add'
    end

    args = [ "advfirewall", "firewall", fw_action, "rule",
             "name=\"#{resource[:name]}\"", "description=\"#{resource[:description]}\"",
             "dir=#{resource[:direction]}", "action=#{resource[:action]}", "enable=#{resource[:enabled]}",
             "protocol=#{resource[:protocol]}", "localport=#{resource[:local_port]}"
           ]
    args
  end

end