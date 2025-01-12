require 'devise/mapping'

module Devise #:nodoc:
  module Autosigninable #:nodoc:
    module Helpers
      # Create the link to autosignin url based on resource with given
      # link_text.
      # Example: link_to_autosignin(user, user.email).
      def link_to_autosignin(resource, link_text, options = {})
        link_to link_text, auto_signin_url_for(resource), options
      end

      # Return autosignin url for given resource
      def auto_signin_url_for(resource)
        resource_name = resource.class.to_s.downcase
        send("#{resource_name}_autosignin_url",
             { :"#{resource_name}_id" => resource.id,
               :autosignin_token      => resource.autosignin_token })
      end

      # Sign in and tries to redirect first to given url and
      # then to the url specified by after_sign_in_path_for.
      #
      # If resource is blank then tries redirect to given url
      # or root url.
      def sign_in_and_redirect_to_url(resource = nil, url = nil)
        if resource
          sign_out(resource)
          sign_in(resource)
          redirect_to url || after_sign_in_path_for(resource)
        else
          redirect_to url || root_url
        end
      end
    end
  end
end

::ActionView::Base.send :include, Devise::Autosigninable::Helpers
