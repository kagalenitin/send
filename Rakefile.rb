begin
  require 'rspec/core/rake_task'

  task default: :spec

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = '--tag smoke'
    t.bundle exec "parallel_rspec -n #{ENV['NODES']} ./spec/features/*"
  end

  RSpec::Core::RakeTask.new(:all) do |t|
    t.rspec_opts = '--tag regression'
    t.bundle exec "parallel_rspec -n #{ENV['NODES']} ./spec/features/*"
  end

  RSpec::Core::RakeTask.new(:api_spec) do |t|
    t.rspec_opts = '--tag smoke'
    t.bundle exec "parallel_rspec -n #{ENV['NODES']} ./spec/api_features/*"
  end

  RSpec::Core::RakeTask.new(:api_all) do |t|
    t.rspec_opts = '--tag regression'
    t.bundle exec "parallel_rspec -n #{ENV['NODES']} ./spec/api_features/*"
  end
  task spec: :set_defaults
  task all: :set_defaults

  task :set_defaults do
    ENV['APP_HOST'] = ENV['APP_HOST'] ||= 'http://qaeval.herokuapp.com/'
  end

rescue LoadError => e
  raise unless e.message =~ /rspec/
  puts 'please install rspec first!'
end
