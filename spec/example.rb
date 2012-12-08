define_options :production do |opts|
  opts.user = ENV["USER"]
  opts.process_name = "%(program_name)_%(process_number)" 
  opts.environment = {
    :HOME => ENV["HOME"],
    :RAILS_ENV => ENV["RAILS_ENV"]
  }
end

define_program :resque_web, :command => "bundle exec resque-web"

define_program :resque_scheduler do |program|
  program[:command] = "bundle exec rake resque:scheduler"
end

define_program :resque_worker do |program|
  program.command = "bundle exec rake resque:work"
end

define_group :main, :with_options => :production do |out| 
  out.program :resque_worker, :num_procs => 3
  out.program :resque_scheduler
end

define_group :web, :with_options => :production do |out|
  out.program :resque_web
end
