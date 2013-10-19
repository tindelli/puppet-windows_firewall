require 'rspec-system/spec_helper'
require 'rspec-system-puppet/helpers'
require 'rspec-system-serverspec/helpers'
include Serverspec::Helper::RSpecSystem
include Serverspec::Helper::DetectOS
include RSpecSystemPuppet::Helpers

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Enable colour
  c.tty = true

  c.include RSpecSystemPuppet::Helpers

  # This is where we 'setup' the nodes before running our tests
  c.before :suite do
    # Install puppet

    #TODO: rspec-system needs windows support but
    #   for now it's safe to assume the vagrant box has puppet installed (if created by packer)
    #   https://github.com/joefitzgerald/packer-windows
    #puppet_install

    # Install modules and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'apache')
    shell('puppet module install puppetlabs-concat --version 1.0.0')
    shell('puppet module install puppetlabs-stdlib --version 2.4.0')
  end
end