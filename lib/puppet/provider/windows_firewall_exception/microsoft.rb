require 'puppet/type'

Puppet::Type.type(:windows_firewall_exception).provide(:microsoft) do

  defaultfor :operatingsystem => :windows
  confine    :operatingsystem => :windows

  #TODO: using the path directly doesn't seem right
  commands :netsh => 'C:\\Windows\\System32\\netsh.exe'

  def self.instances
    []
  end

  def exists?
    Puppet.debug("Checking the existence of firewall exception value: #{self}")
    found = false
    begin
      #TODO:
    end
    found
  end

  def create
    Puppet.debug("Creating firewall exception: #{self}")
    netsh gen_args
  end

  def flush
    Puppet.debug("Flushing firewall exception: #{self}")
    return if resource[:ensure] == :absent
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

    args = "advfirewall firewall #{fw_action} rule "
    args << "name=\"#{resource[:name]}\" description=\"#{resource[:description]}\" "
    args << "dir=#{direction} action=#{resource[:action]} enable=#{resource[:enabled]} "
    args << "protocol=#{resource[:protocol]} localport=#{resource[:local_port]}"
  end

end