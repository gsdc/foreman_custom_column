# ForemanCustomColumn

*Introdction here*

## Installation

See [How_to_Install_a_Plugin](http://projects.theforeman.org/projects/foreman/wiki/How_to_Install_a_Plugin)
for how to install Foreman plugins

## Usage

### config
`/etc/foreman/plugins/foreman_custom_column.yaml`
```yaml
:custom_column:
  - :page: hosts/_list
    :profiles:
      - :id: general
        :label: General
        :default: true
        :columns:
          - :id: host_lniks
            :header:
              :label: Host Links
              :sortable: false
              :width: 134px
              :class: hidden-tablet hidden-xs
            :content:
              :class: hidden-tablet hidden-xs ellipsis
              :callback: |
                ->(host) {
                  link_to("C", "/webcon/=#{host.name}", { :class => "btn btn-info", :target => "_new" }) +
                  if host.name != SETTINGS[:fqdn].to_s
                    link_to("N", "http://#{host.name}", { :class => "btn btn-info", :target => "_new" } )
                  else
                    link_to("N", "http://#{host.ip}", { :class => "btn btn-info", :target => "_new" } )
                  end +
                  if host.bmc_available? 
                    link_to("B", "https://#{host.sp_ip}", { :class => "btn btn-info", :target => "_new" } )
                  else
                    ""
                  end +
                  if host.params['hypervisor_host'] && !host.params['hypervisor_host'].empty?
                    link_to("H", "/webcon/=#{host.params['hypervisor_host']}/machines", { :class => "btn btn-info", :target => "_new" } )
                  else
                    ""
                  end +
                  if host.params['sysdig_falco_sidekick_ui_port'] && !host.params['sysdig_falco_sidekick_ui_port'].empty?
                    link_to("F", "http://#{host.name}:#{host.params['sysdig_falco_sidekick_ui_port']}", { :class => "btn btn-info", :target => "_new" } )
                  else
                    ""
                  end +
                  if host.params['sysdig_inspect_port'] && !host.params['sysdig_inspect_port'].empty?
                    link_to("S", "http://#{host.name}:#{host.params['sysdig_inspect_port']}", { :class => "btn btn-info", :target => "_new" } )
                  else
                    ""
                  end
                }

```

### install
```bash
git clone https://github.com/gsdc/foreman_custom_column.git
cd foreman_custom_column
gem build foreman_custom_column.gemspec
gem install -f -i /usr/share/gems foreman_custom_column-0.0.1.gem
cat > /usr/share/foreman/bundler.d/Gemfile.local.rb << '__EOF_GEM__'
gem 'foreman_custom_column'
__EOF_GEM__
/usr/bin/foreman-maintain service restart
```

## TODO

*Todo list here*

## Contributing

Fork and send a Pull Request. Thanks!

## Copyright

Copyright (c) *year* *your name*

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

