module ForemanCustomColumn
  class Engine < ::Rails::Engine
    isolate_namespace ForemanCustomColumn
    engine_name 'foreman_custom_column'

    initializer 'foreman_custom_column.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_custom_column do
        requires_foreman '>= 3.7.0'
        register_gettext

        TRUE_VALUES = [true, 1, "1", "t", "T", "true", "True", "TRUE", "on", "On", "ON"].to_set.freeze
        MOUNT_POINT_MAP = {
          "hosts/_list" => {
            :header => :hosts_table_column_header,
            :content => :hosts_table_column_content
          }
        }.freeze

        SETTINGS[:custom_column].kind_of?(Array) && SETTINGS[:custom_column].each do |item|
          page_name = item[:page]
          if !page_name.nil? && !page_name.empty?
            extend_page "#{page_name}" do |context|
            item[:profiles].kind_of?(Array) && item[:profiles].each do |profile|
                profile_id = profile[:id]
                profile_label = profile[:label]
                mount_point_header = MOUNT_POINT_MAP[page_name][:header]
                mount_point_content = MOUNT_POINT_MAP[page_name][:content]
                if [ profile_id, profile_label, mount_point_header, mount_point_content ].all? { |x| !x.nil? && (!x.kind_of?(String) || !x.empty?) }
                  default = TRUE_VALUES.include?(profile[:default])
                  context.with_profile profile_id.to_sym, _(profile_label), default: default do
                    profile[:columns].kind_of?(Array) && profile[:columns].each do |column|
                      column_id = column[:id]
                      column_header_label = column[:header][:label]
                      column_content_callback_def = column[:content][:callback]
                      begin
                        column_content_callback = !column_content_callback_def.nil? ? eval(column_content_callback_def) : nil
                      rescue StandardError => e
                        Rails.logger.warn "ForemanCustomColumn: skipping column: #{page_name} -> #{profile_id} -> #{column_id} (#{e})"
                      end
                      if [ column_id, column_header_label, column_content_callback ].all? { |x| !x.nil? && (!x.kind_of?(String) || !x.empty?) }
                        add_pagelet mount_point_header, { key: column_id.to_sym, label: _(column_header_label), sortable: TRUE_VALUES.include?(column[:header][:sortable]), width: column[:header][:width], class: column[:header][:class] }.delete_if { |k, v| v.nil? || (v.kind_of?(String) && v.empty?) }
                        add_pagelet mount_point_content, { key: column_id.to_sym, class: column[:content][:class], callback: column_content_callback }.delete_if { |k, v| v.nil? || (v.kind_of?(String) && v.empty?) }
                      end
                    end
                  end
                end
              end
            end
          end
        end

      end
    end

  end
end
