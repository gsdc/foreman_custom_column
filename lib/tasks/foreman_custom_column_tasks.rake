require 'rake/testtask'

# Tasks
namespace :foreman_custom_column do
  namespace :example do
    desc 'Example Task'
    task task: :environment do
      # Task goes here
    end
  end
end

# Tests
namespace :test do
  desc 'Test ForemanCustomColumn'
  Rake::TestTask.new(:foreman_custom_column) do |t|
    test_dir = File.expand_path('../../test', __dir__)
    t.libs << 'test'
    t.libs << test_dir
    t.pattern = "#{test_dir}/**/*_test.rb"
    t.verbose = true
    t.warning = false
  end
end

namespace :foreman_custom_column do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_custom_column) do |task|
        task.patterns = ["#{ForemanCustomColumn::Engine.root}/app/**/*.rb",
                         "#{ForemanCustomColumn::Engine.root}/lib/**/*.rb",
                         "#{ForemanCustomColumn::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end

    Rake::Task['rubocop_foreman_custom_column'].invoke
  end
end

Rake::Task[:test].enhance ['test:foreman_custom_column']

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task['jenkins:unit'].enhance ['test:foreman_custom_column', 'foreman_custom_column:rubocop']
end
