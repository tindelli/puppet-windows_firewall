require 'puppet/type'

Puppet::Type.newtype(:windows_firewall_exception) do
  @doc = <<-EOT
    Manages firewall exceptions on Windows systems.

    TCP/UCP port exceptions as well as full program exceptions are supported.
  EOT

  ensurable

  newparam(:display_name, :namevar => true) do
    desc "The unique name that is displayed to indentify this exception"

    validate do |display_name|
      fail("Invalid display_name #{display_name}") unless display_name.is_a? String
    end
  end

  newparam(:description) do
    desc "A freeform text description explaining the purpose of this exception."

    validate do |description|
      fail("Invalid description #{description}") unless description.is_a? String
    end
  end

  #newparam(:program) do
  #  desc ""
  #
  #  validate do |program|
  #
  #  end
  #end

  newparam(:action) do
    desc "The intended purpose of this exception, either allow or block."

    newvalues(:allow, :block)
    defaultto :allow
  end

  newparam(:direction) do
    desc "The direction through the firewall that this exception is managing, either in or out."

    newvalues(:in, :out)
    defaultto :in
  end

  newparam(:protocol) do
    desc "The specific protocol that the exception manages, either tcp or udp."

    newvalues(:tcp, :udp)
    defaultto :tcp
  end

  newparam(:local_port) do
    desc "The local port that should be managed by this exception. The data should be specified
      as a integer in the range: "

    validate do |local_port|
     fail("Invalid port #{local_port}") unless local_port =~ /[0-9]{1,5}/
    end
    munge do |local_port|
       Integer(local_port)
    end
  end

  newparam(:enabled, :boolean => true) do
    desc "The status of the exception, indicating if exception is active or not"

    newvalues(:true, :false)
    defaultto true

    validate do |value|
      case value
        when true, /^true$/i, :true, false, /^false$/i, :false, :undef, nil
          true
        else
          # We raise an ArgumentError and not a Puppet::Error so we get manifest
          # and line numbers in the error message displayed to the user.
          raise ArgumentError.new("Validation Error: purge_values must be true or false, not #{value}")
      end
    end

    munge do |value|
      case value
        when true, /^true$/i, :true
          "yes"
        else
          "no"
      end
    end
  end
end
