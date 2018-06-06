class AddAutosigninableTo<%= table_name.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def up
    change_table :<%= table_name %> do |t|
      t.string :autosignin_token, limit: 40
    end
    add_index :<%= table_name %>, :autosignin_token, unique: true
  end

  def down
    remove_column :<%= table_name %>, :autosignin_token
  end
end
