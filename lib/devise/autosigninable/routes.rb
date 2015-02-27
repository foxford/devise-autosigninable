ActionDispatch::Routing::Mapper.class_eval do
  protected

  # Setup routes for +AutosigninController+.
  def devise_autosignin(mapping, controllers)
    get "/:#{mapping.name}_id/autosignin/:autosignin_token",
      :controller => controllers[:autosignin],
      :action => 'create',
      :as => :autosignin
  end
end
