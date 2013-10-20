require 'puppet/type'

#TODO: add support for windows xp + server 2003
Puppet::Type.type(:windows_firewall_exception).provide(:microsoft) do

  defaultfor :operatingsystem => :windows
  confine    :operatingsystem => :windows

  commands :netsh => "#{ENV['SYSTEMROOT']}\\System32\\netsh.exe"

  def self.instances
    []
  end

  def exists?
    Puppet.debug("Checking the existence of firewall exception value: #{self}")
    #TODO: test this for windows 2003
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
    netsh generate_arguments
  end

  def destroy
    Puppet.debug("Destroying firewall exception: #{self}")
    netsh generate_arguments
  end

  #TODO: refactor this out into two classes within the PuppetX namespace
  def generate_arguments

    resource[:ensure] == :absent ? fw_action = 'delete' : fw_action = 'add'

    if (discover_os =~ /Windows Server 2003/) or (discover_os =~ /Windows XP/)

      resource[:enabled] = 'yes' ? mode = 'ENABLED' : mode = 'DISABLED'

      args = [ "firewall", fw_action]

      if resource[:program].empty?
        fw_command = 'portopening'

      else
        fw_command = 'allowedprogram'
      end

      args.concat([fw_command, "name=\"#{resource[:name]}\"", "mode=#{mode}", "enable=#{resource[:enabled]}"])

      if resource[:program].empty?
        args.concat(["protocol=#{resource[:protocol]}", "port=#{resource[:local_port]}"])
      else
        args.concat(["program=#{resource[:program]}"])
      end
    else
      args = [ "advfirewall", "firewall", fw_action, "rule",
               "name=\"#{resource[:name]}\"", "description=\"#{resource[:description]}\"",
               "dir=#{resource[:direction]}", "action=#{resource[:action]}", "enable=#{resource[:enabled]}"
             ]

      if resource[:program].empty?
        args.concat(["protocol=#{resource[:protocol]}", "local_port=#{resource[:local_port]}"])
      else
        args.concat(["program=#{resource[:program]}"])
      end
    end

    args
  end

  #TODO: pull this out to PuppetX ?
  def discover_os
    require 'win32/registry'

    operatingsystemversion = "unknown"
    begin
      require 'win32/registry'

      Win32::Registry::HKEY_LOCAL_MACHINE.open('Software\Microsoft\Windows NT\CurrentVersion') do |reg|
        reg.each do |name,type,data|
          if name.eql?("ProductName")
            operatingsystemversion = data
          end
        end
      end
    rescue

    end
    operatingsystemversion
  end

end