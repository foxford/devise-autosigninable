require 'rails/generators'
require 'rails/generators/migration'

class DeviseAutosigninableGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  include Rails::Generators::Migration

  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      migration_number = Time.now.utc.strftime('%Y%m%d%H%M%S').to_i
      migration_number += 1
      migration_number.to_s
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

  def copy_migration
    migration_template 'migration.rb',
                       "db/migrate/add_autosigninable_to_#{table_name}.rb",
                       migration_version: migration_version
  end

  def migration_version
    if Rails.version.start_with? '5'
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
    end
  end
end
