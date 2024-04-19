#!/usr/bin/env ruby
require 'find'
require 'fileutils'

class String
  def camel_case
    return self if self !~ /_/ && self =~ /[A-Z]+.*/
    split('_').map(&:capitalize).join
  end
end

def usage
  puts 'This script renames the template plugin to a name of your choice'
  puts 'Please supply the desired plugin name in snake_case, e.g.'
  puts ''
  puts '    rename.rb my_awesome_plugin'
  puts ''
  exit 0
end

usage if ARGV.size != 1

snake = ARGV[0]
camel = snake.camel_case
camel_lower = camel[0].downcase + camel[1..-1]

if snake == camel
  puts "Could not camelize '#{snake}' - exiting"
  exit 1
end

Find.find('.') do |path|
  next unless File.file?(path)
  next if path =~ /\.git/
  next if path == './rename.rb'

  # Change content on all files
  tmp_file_1 = "#{path}.1.tmp"
  tmp_file_2 = "#{path}.2.tmp"
  system(%(sed 's/foreman_plugin_template/#{snake}/g' #{path} > #{tmp_file_1}))
  system(%(sed 's/ForemanPluginTemplate/#{camel}/g' #{tmp_file_1} > #{tmp_file_2}))
  system(%(sed 's/foremanPluginTemplate/#{camel_lower}/g' #{tmp_file_2} > #{path}))
  system(%(rm #{tmp_file_1}))
  system(%(rm #{tmp_file_2}))
end

old_dirs = []
Find.find('.') do |path|
  next unless File.directory?(path)
  next if path =~ /\.git/

  if path =~ /foreman_plugin_template$/i
    new = path.gsub('foreman_plugin_template', snake)
    FileUtils.cp_r(path, new)
    old_dirs << path
  end
end
FileUtils.rm_rf(old_dirs)

Find.find('.') do |path|
  next unless File.file?(path)
  next if path =~ /\.git/

  if path =~ /foreman_plugin_template/i
    new = path.gsub('foreman_plugin_template', snake)
    FileUtils.mv(path, new)
  end
end

FileUtils.mv('README.plugin.md', 'README.md')

puts 'All done!'
puts "Add this to Foreman's bundler configuration:"
puts ''
puts "  gem '#{snake}', :path => '#{Dir.pwd}'"
puts ''
puts 'Happy hacking!'
