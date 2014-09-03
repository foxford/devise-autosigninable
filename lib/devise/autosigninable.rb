require 'devise'

begin
  Rails::Engine
rescue
else
  module Devise::Autosigninable
    class Engine < Rails::Engine
    end
  end
end

Devise.add_module :autosigninable,
  :controller => :autosignin,
  :model => 'devise/autosigninable/model',
  :route => :autosignin,
  :strategy => true

require 'devise/autosigninable/routes'
require 'devise/autosigninable/helpers'
require 'devise/autosigninable/strategy'
