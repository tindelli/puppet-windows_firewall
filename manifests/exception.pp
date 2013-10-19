# Class windows_firewall::exception
#
# This class manages exceptions in the windows firewall
#
# Parameters:
#   [*ensure*]          - Control the existence of a rule
#   [*direction]        - Specifies whether this rule matches inbound or outbound network traffic.
#   [*action]           - Specifies what Windows Firewall with Advanced Security does to filter network packets that match the criteria specified in this rule.
#   [*enabled]          - Specifies whether the rule is currently enabled.
#   [*protocol]         - Specifies that network packets with a matching IP protocol match this rule.
#   [*local_port]       - Specifies that network packets with matching IP port numbers matched by this rule.
#   [*display_name]     - Specifies the rule name assigned to the rule that you want to display
#   [*key_name]         - Specifies the name of rule as it appears in the registry
#   [*description]      - Provides information about the firewall rule.
#
#  WARNING!:
#  This class has been deprecated in favor of the windows_firewall_exception native type and will be removed from a future version
#
define windows_firewall::exception(
  $ensure = 'present',
  $direction = '',
  $action = '',
  $enabled = 'yes',
  $protocol = '',
  $local_port = '',
  $program = undef,
  $display_name = '',
  $description = '',
  $key_name = $name,

) {

  warning("The class windows_firewall::exception has been deprecated in favor of the windows_firewall_exception native type and will be removed from a future version")

  windows_firewall_exception {
    ensure       = $ensure,
    direction    = $direction,
    action       = $action,
    enabled      = $enabled,
    protocol     = $protocol,
    local_port   = $local_port,
    program      = $program,
    display_name = $display_name,
    description  = $description,
    key_name     = $key_name
  }
}
