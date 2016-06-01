
### [Issues](https://bitbucket.org/rstackers/rstacks/issues?status=new&status=open) for fix-me's, works-in-progress, incoming features, proposed enhancements.

> [archive](https://bitbucket.org/rstackers/rstacks/wiki/Home) -- dated to about mid-July

----

### [Wiki References](https://bitbucket.org/rstackers/rstacks/wiki/browse/) for commands, instructions, and dealing with common errors.

>Cheat sheets, tutorials, and standard processes for installing, running, and debugging the app.

----

### Troubleshooting on EC2

_14 April 2016_

**503 Service Unavailable - No server is avaialbe to handle this request** along with 
```shell
ia@mh:~/dev/rstacks (dev) $ ssh rs_prod
ssh_exchange_identification: read: Connection reset by peer
ia@mh:~/dev/rstacks (dev) $ 
```

Checking my email reveals that I got an email at midnight from the Cron Daemon informing me that it was unable to backup the database because it couldn't allocate the memory. (`'spawn': Cannot allocate memoery - [...] Errno::ENOMEM`). One minute later the same error caused the logs rotater to `ENOMEM` out. 




----

- a `503 Service Unavailable - No server is available to handle this request.`. I think this means Apache is down. Could be you're mid deploy. 

_13 April 2016._

This one has been a persistent bitch today. I think it's either because I fucked up the `application_controller` tinkering with it trying to get it to monkeypatch in staging.rstacks.org as a fake subdomain or... or, Passenger is being an asshole, or, the instance is running too close to redline on MEM and causing Apache and NGINX to be twiffley about handling their reverse proxification/servitudinal duties. A rocky road today. 

I think it must have been the tailspin of a 301 caused by my damn cleverness in the `application_controller`. It appears to be working now. **Bastard.** 

```shell
 ** Auto role: haproxy => production.rstacks.org, {:platform=>"linux", :provider=>"aws"}
 ** Auto role: solr_sunspot => production.rstacks.org, {:platform=>"linux", :provider=>"aws"}
 ** Auto role: web => production.rstacks.org, {:platform=>"linux", :provider=>"aws"}
 ** Auto role: web_tools => production.rstacks.org, {:platform=>"linux", :provider=>"aws"}
  * 2016-04-13 18:59:14 executing `production'
    triggering start callbacks for `rubber:tail_logs'
  * 2016-04-13 18:59:14 executing `multistage:ensure'
  * 2016-04-13 18:59:14 executing `rubber:tail_logs'
Log files to tail [/mnt/rstacks-production/current/log/production*.log]:   * executing "tail -qf /mnt/rstacks-production/current/log/production*.log"
    servers: ["production.rstacks.org"]
    [production.rstacks.org] executing command

[production]      rack (1.6.4) lib/rack/sendfile.rb:113:in `call'
[production]    
[production]      railties (4.2.0) lib/rails/engine.rb:518:in `call'
[production]    
[production]      railties (4.2.0) lib/rails/application.rb:164:in `call'
[production]    
[production]      /usr/lib/ruby/vendor_ruby/phusion_passenger/rack/thread_handler_extension.rb:97:in `process_request'
[production]    
[production]      /usr/lib/ruby/vendor_ruby/phusion_passenger/request_handler/thread_handler.rb:160:in `accept_and_process_next_request'
[production]    
[production]      /usr/lib/ruby/vendor_ruby/phusion_passenger/request_handler/thread_handler.rb:113:in `main_loop'
[production]    
[production]      /usr/lib/ruby/vendor_ruby/phusion_passenger/request_handler.rb:416:in `block (3 levels) in start_threads'
[production]    
[production]      /usr/lib/ruby/vendor_ruby/phusion_passenger/utils.rb:113:in `block in create_thread_and_abort_on_exception'
[production]    
[production]    
[production]    
```

----

This happens a lot: 
```shell
    command finished in 1782ms
    triggering after callbacks for `deploy:restart'
  * 2016-04-13 18:54:39 executing `rubber:apache:reload'
  * 2016-04-13 18:54:39 executing `rubber:apache:serial_reload'
  * 2016-04-13 18:54:39 executing `rubber:apache:_serial_task_serial_reload_production'
    triggering before callbacks for `rubber:apache:_serial_task_serial_reload_production'
  * 2016-04-13 18:54:39 executing `rubber:passenger:serial_remove_from_pool_reload_production'
  * executing "sudo -p 'sudo password: '  bash -l -c 'rm -f /mnt/rstacks-production/releases/*/public/httpchk.txt && sleep 5'"
    servers: ["production.rstacks.org"]
    [production.rstacks.org] executing command
    command finished in 5402ms
  * executing "sudo -p 'sudo password: '  bash -l -c 'if ! ps ax | grep -v grep | grep -c apache2 &> /dev/null; then service apache2 start; else service apache2 reload; fi'"
    servers: ["production.rstacks.org"]
    [production.rstacks.org] executing command
 ** [out :: production.rstacks.org] * Reloading web server apache2
 ** [out :: production.rstacks.org] 
 ** [out :: production.rstacks.org] 
 ** [out :: production.rstacks.org] *
 ** [out :: production.rstacks.org] 
    command finished in 891ms
    triggering after callbacks for `rubber:apache:_serial_task_serial_reload_production'
  * 2016-04-13 18:54:45 executing `rubber:passenger:serial_add_to_pool_reload_production'
 ** Waiting for passenger to startup
  * executing "sudo -p 'sudo password: '  bash -l -c 'while ! curl -s -f http://localhost:$CAPISTRANO:VAR$/ &> /dev/null; do echo .; done'"
    servers: ["production.rstacks.org"]
    [production.rstacks.org] executing command
    command finished in 341ms
  * executing "sudo -p 'sudo password: '  bash -l -c 'touch /mnt/rstacks-production/current/public/httpchk.txt'"
    servers: ["production.rstacks.org"]
    [production.rstacks.org] executing command
 ** [out :: production.rstacks.org] /bin/bash: /usr/bin/sudo: Cannot allocate memory
    command finished in 3303ms
failed: "/bin/bash -l -c 'sudo -p '\\''sudo password: '\\''  bash -l -c '\\''touch /mnt/rstacks-production/current/public/httpchk.txt'\\'''" on production.rstacks.org
```
From what I gather it means that the instance is redlining. Power hungry MySQL, the 770M of gems, the backups... 99 bitches. 

----
_11 Apr 2016_
Noticed production was down this morning. Got an error on `ssh`ing into the ~`connection reset by peer`. The EC2 logs showed the system was out of memory. Rebooting via the EC2 dash was unsuccessful. Stopped instance via EC2 and restarted. **This gives the instance new IPs.** Replaced all ips and instance id in Rubber's `instance-production.yml` file to new. Pointed DNS A Zone file to new ip. Could now ssh in. BUT, `cap` connection still yields `connection failed for: production.rstacks.org (Timeout::Error: execution expired)`. 

> `cap -T` shows available Capistrano commands, including Rubber.

`cap rubber:start` connects. 
`cap rubber:tail_logs` yielding:
```shell
[production]    
[production]    I, [2016-04-11T09:44:10.230232 #2598]  INFO -- : Processing by ProjectsController#index as HTML
[production]    
[production]    I, [2016-04-11T09:44:10.239770 #2598]  INFO -- : Redirected to http://rstacks.org/
[production]    
[production]    I, [2016-04-11T09:44:10.239869 #2598]  INFO -- : Filter chain halted as :redirect_to_org rendered or redirected
[production]    
[production]    I, [2016-04-11T09:44:10.240063 #2598]  INFO -- : Completed 301 Moved Permanently in 10ms (ActiveRecord: 0.0ms)
[production]    
[production]    I, [2016-04-11T09:45:23.460651 #2598]  INFO -- : Started GET "/" for 209.6.198.20 at 2016-04-11 09:45:23 -0400
[production]    I, [2016-04-11T09:45:23.463450 #2598]  INFO -- : Processing by ProjectsController#index as HTML
[production]    I, [2016-04-11T09:45:23.464824 #2598]  INFO -- : Redirected to http://rstacks.org/
[production]    I, [2016-04-11T09:45:23.464958 #2598]  INFO -- : Filter chain halted as :redirect_to_org rendered or redirected
[production]    I, [2016-04-11T09:45:23.465113 #2598]  INFO -- : Completed 301 Moved Permanently in 2ms (ActiveRecord: 0.0ms)
```

`cap deploy:restart && cap rubber:tail_logs` yields 

```shell
[production]      rack (1.6.4) lib/rack/sendfile.rb:113:in `call'
[production]    
[production]      railties (4.2.0) lib/rails/engine.rb:518:in `call'
[production]    
[production]      railties (4.2.0) lib/rails/application.rb:164:in `call'
[production]    
[production]      /usr/lib/ruby/vendor_ruby/phusion_passenger/rack/thread_handler_extension.rb:94:in `process_request'
[production]    
[production]      /usr/lib/ruby/vendor_ruby/phusion_passenger/request_handler/thread_handler.rb:157:in `accept_and_process_next_request'
[production]    
[production]      /usr/lib/ruby/vendor_ruby/phusion_passenger/request_handler/thread_handler.rb:110:in `main_loop'
[production]    
[production]      /usr/lib/ruby/vendor_ruby/phusion_passenger/request_handler.rb:415:in `block (3 levels) in start_threads'
[production]    
[production]      /usr/lib/ruby/vendor_ruby/phusion_passenger/utils.rb:112:in `block in create_thread_and_abort_on_exception'
[production]    
[production]    
```

Figure why the hell not and run a deploy to production `rake t_minus:production`. Successful deploy, but still getting Phusion Passenger error about `can't find user to lower privilege to` on visiting the ip in the browser.

Run `cap rubber:update`. Then another `cap deploy:restart`. And we're golden :thumbsup:.  


----
### Specific version issues
The current versions of `WordToMarkdown` (currently either at 1.1.5 or 1.1.7) will break if you try to use LibreOffice 5+. Instead use LibreOffice 4.2.8.2, which is now officially deprecated, but an archive download is available [here](https://downloadarchive.documentfoundation.org/libreoffice/old/4.2.8.2/mac/x86_64/). And no, you can't find any versions of LibreOffice 4~ on `homebrew`


There iswas a bug having to do with the Rails 4 default counter_cache method that would tally children for a parent, resulting in a 2x count. As of Rails 4.2 the bug hasn't been resolved beyond hoarse monkey patching. Using `counter_culture` gem solves the problem. 

In order to update, fix, or otherwise re-establish these count caches using the gem, run:
```ruby
Model.counter_culture_fix_counts 
```
[magnusvk](https://github.com/magnusvk/counter_culture) recommends running this weekly anyways. 


----

### Git structure
```
<test-merge> branches used occasionally for testing weird migrations and gem integrations and stuff
#livefastprunelater

master 
    \<master-staging-dev-feature-test-merge>
    \staging
        /<staging-dev-feature-test-merge> 
        \dev
            \<dev-feature-test-merge>
            \dev-<feature>
```     

```
    100 files
     200 files
     249 text files.
classified 249 files
Duplicate file check 249 files (233 known unique)
Unique:      100 files                                          
Unique:      200 files                                          
     247 unique files.                              
Counting:  100
Counting:  200
      16 files ignored.

http://cloc.sourceforge.net v 1.64  T=1.46 s (167.4 files/s, 13325.7 lines/s)
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
ERB                            136           2366             21           8506
Ruby                            58            812            974           3183
SASS                            43            360            669           1619
Javascript                       5            137            720             74
HTML                             1              2              1             35
CSS                              1              2             17              0
CoffeeScript                     1              0              3              0
-------------------------------------------------------------------------------
SUM:                           245           3679           2405          13417
-------------------------------------------------------------------------------
```