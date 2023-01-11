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

module Devise
  # Indicator: expire autosignin token.
  mattr_accessor :autosignin_expire
  @@autosignin_expire = false

  # The number of retries for autosignin token generation.
  mattr_accessor :autosignin_generation_retry_count
  @@autosignin_generation_retry_count = 20
end

Devise.add_module :autosigninable,
                  controller: :autosignin,
                  model: 'devise/autosigninable/model',
                  route: :autosignin,
                  strategy: true

require 'devise/autosigninable/routes'
require 'devise/autosigninable/helpers'
require 'devise/autosigninable/strategy'
