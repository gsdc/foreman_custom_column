module ForemanCustomColumn
  class Engine < ::Rails::Engine
    isolate_namespace ForemanCustomColumn
    engine_name 'foreman_custom_column'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer 'foreman_custom_column.load_app_instance_data' do |app|
      ForemanCustomColumn::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_custom_column.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_custom_column do
        requires_foreman '>= 3.7.0'
        register_gettext

        # Add Global files for extending foreman-core components and routes
        register_global_js_file 'global'

        # Add permissions
        security_block :foreman_custom_column do
          permission :view_foreman_custom_column, { :'foreman_custom_column/example' => [:new_action],
                                                      :'react' => [:index] }
        end

        # Add a new role called 'Discovery' if it doesn't exist
        role 'ForemanCustomColumn', [:view_foreman_custom_column]

        # add menu entry
        sub_menu :top_menu, :plugin_template, icon: 'pficon pficon-enterprise', caption: N_('Plugin Template'), after: :hosts_menu do
          menu :top_menu, :welcome, caption: N_('Welcome Page'), engine: ForemanCustomColumn::Engine
          menu :top_menu, :new_action, caption: N_('New Action'), engine: ForemanCustomColumn::Engine
        end

        # add dashboard widget
        widget 'foreman_custom_column_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1
      end
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do

      begin
        Host::Managed.send(:include, ForemanCustomColumn::HostExtensions)
        HostsHelper.send(:include, ForemanCustomColumn::HostsHelperExtensions)
      rescue => e
        Rails.logger.warn "ForemanCustomColumn: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanCustomColumn::Engine.load_seed
      end
    end
  end
end
