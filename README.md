# Warehouse Supervisor

Easily create [supervisor](http://supervisord.org/) configuration files and run them in dev mode.

## Installation

Add this line to your application's Gemfile:

    gem 'warehouse_supervisor'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install warehouse_supervisor

## Usage

Warehouse Supervisor may be used either from its own CLI interface or from rake, both provide the same commands:

### print

    warehouse_supervisor print -g production -c config.yml processes.conf.erb

or

    rake warehouse_supervisor:print WS_GROUP=production CONFIG=config.yml TEMPLATES=processes.conf.erb
    
This will print the programs in config.yml, using the templates in processes.conf.erb. 

Note that only [program:x] sections are printed. The result of this command is intended to be redirected to a file to be
[included in your main supervisord.conf file](http://supervisord.org/configuration.html#include-section-settings)

### start

    warehouse_supervisor start -g production -c config.yml processes.conf.erb

or

    rake warehouse_supervisor:start WS_GROUP=production CONFIG=config.yml TEMPLATES=processes.conf.erb


This will start a supervisor instance running in the foreground with the config you specified

Both these commands take the following options:

  * `--group | -g`, `WS_GROUP=` Group to use.
  * `--config | -c`, `CONFIG=` Definition file.
  * ` `, `TEMPLATES=` Templates file.

## Files

Warehouse Supervisor needs 2 files to work:

- Templates file
- Definitions file

### Templates file

This is an erb file where you'll define the different *program templates* that your app uses, for example:

    <% template :resque_web do %>
      user = <%= user || ENV["USER"] %>
      directory = <%=dir || ENV["RAILS_ROOT"]%>
      command = bundle exec resque-web -F -L -p 5678 config/resque_config.rb 
      environment = HOME='<%=home || ENV["HOME"]%>',USER=<%=user || ENV["USER"]%>
    <% end %>

Each program template that you need will be define in a `template` block.

### Definitions file

This is a yml file where you can define the *programs* that supervisor will run. For example:

    development:
      resque_web:
        template: resque_web
        dir: "/my/dir"

It defines groups of programs and for each one defines the template to be used and the variables 
that each program requires.

For each program Warehouse Supervisor will compile its template with the provided variables, and it'll add this to
the output. This way you may use generic templates to define similar programs.

For a full example of both files check the examples dir.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

