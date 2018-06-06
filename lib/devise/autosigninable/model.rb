module Devise
  module Models
    module Autosigninable
      extend ActiveSupport::Concern

      included do
        before_create :reset_autosignin_token

        # Indicator: expire autosignin token.
        mattr_accessor :autosignin_expire
        @@autosignin_expire = false
      end

      module ClassMethods
        RETRY_COUNT = 20

        # Generate autosignin tokens unless already exists and save the records.
        def ensure_all_autosignin_tokens(batch_size = 500)
          where(autosignin_token: nil).find_each(batch_size: batch_size) do |resource|
            resource.ensure_autosignin_token!
          end
        end

        # Generate autosignin tokens and save the records.
        def reset_all_autosignin_tokens(batch_size = 500)
          find_each(batch_size: batch_size) do |resource|
            resource.reset_autosignin_token!
          end
        end

        # generation random autosignin token
        def autosignin_token(uniq = true, field = 'autosignin_token')
          if uniq
            RETRY_COUNT.times do
              token = Digest::SHA1.hexdigest("--#{Time.now.utc}--#{rand}--")
              return token unless exists? field => token
            end
            raise Exception.new("Couldn't generate #{self.class}:#{field} for #{RETRY_COUNT} times")
          else
            Digest::SHA1.hexdigest("--#{Time.now.utc}--#{rand}--")
          end
        end

        # Authenticate a user based on authentication token.
        def authenticate_with_autosignin_token(attributes = {})
          key = attributes[primary_key]
          resource = where(primary_key => key).first
          resource if resource.try(:valid_for_autosignin_token_authentication?, attributes)
        end
      end

      def autosigninable?
        true
      end

      def autosigninable_ready?
        !self.autosignin_token.blank?
      end

      # Generate new autosignin token
      def reset_autosignin_token
        self.autosignin_token = self.autosigninable? ? self.class.autosignin_token : nil
      end

      # Generate new autosignin token and save the record.
      def reset_autosignin_token!
        reset_autosignin_token
        self.save
      end

      # Generate autosignin token unless already exists.
      def ensure_autosignin_token
        self.reset_autosignin_token unless self.autosigninable_ready?
      end

      # Generate autosignin token unless already exists and save the record.
      def ensure_autosignin_token!
        self.reset_autosignin_token! unless self.autosigninable_ready?
      end

      # Verifies whether an +incoming_autosignin_token
      # is the user authentication token.
      def valid_autosignin_token?(incoming_autosignin_token)
        incoming_autosignin_token == self.autosignin_token
      end

      # Checks if a resource is valid upon authentication.
      # for verifying whether an user is allowed to sign in or not. If the user
      # is locked, it should never be allowed.
      def valid_for_autosignin_token_authentication?(attributes)
        if (result = valid_autosignin_token?(attributes[:autosignin_token])) && self.class.devise_modules.include?(:lockable)
          self.failed_attempts = 0 if self.class.devise_modules.include?(:lockable)
        else
          if self.class.devise_modules.include?(:lockable)
            self.failed_attempts += 1
            lock_access! if failed_attempts > self.class.maximum_attempts
          end
        end
        reset_autosignin_token! if self.class.autosignin_expire
        save(validate: false) if changed?
        result
      end
    end
  end
end
