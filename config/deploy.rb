# Please install the Engine Yard Capistrano gem
# gem install eycap --source http://gems.engineyard.com
require "eycap/recipes"

set :monit_group,         "osdv"

task :production do

  set :keep_releases,       5
  set :application,         "osdv"
  set :user,                "osdv"
  set :deploy_to,           "/data/#{application}"

  set :dbuser,        "root"
  set :dbpass,        "password"

  set :repository,  "git@github.com:pivotal/osdv.git"
  set :branch, "master"
  set :scm, :git
  set :git_shallow_clone, 1


  # set :deploy_via,          :filtered_remote_cache
  set :deploy_via, :remote_cache
  set :repository_cache,    "cached-copy"

  set :production_database, "osdv_production"
  set :production_dbhost,   "ey05-s00124"

  # comment out if it gives you trouble. newest net/ssh needs this set.
  ssh_options[:paranoid] = false

  role :web, "65.74.186.4:8124"
  role :app, "65.74.186.4:8124", :mongrel => true, :primary => true
  role :db,  "65.74.186.4:8124",  :primary => true

  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
  set :ey,  true
end
#
#task :demo do
#  set :repository,  "git@github.com:pivotal/casebook.git"
#  set :branch, "master"
#  set :scm, :git
#  set :git_shallow_clone, 1
#
#  set :deploy_via, :remote_cache
#  set :repository_cache,    "cached-copy"
#
#  role  :app,       "casebook-demo.pivotallabs.com", :primary => true
#  role  :web,       "casebook-demo.pivotallabs.com"
#  role  :db,        "casebook-demo.pivotallabs.com", :primary => true
#  set   :user,      "pivotal"
#  set   :deploy_to, "/u/apps/casebook"
#
#  # set runner to avoid the error
#  # *** [err :: casebook-demo.pivotallabs.com] sudo: no passwd entry for app!
#  set :runner, 'pivotal'
#
#  set :rails_env, "demo"
#
#  #  set :deploy_via,          :filtered_remote_cache
#  set :ey,  false
#end
#
#namespace :git_repo do
#  task :set_the_correct_branch, :roles => :app do
#
#    if exists?(:head)
#      set :branch, "master"
#    elsif exists?(:tag)
#      set :branch, tag
#    else
#      run "cd #{shared_path}/#{repository_cache} && git fetch origin" || raise("Failure fetching from origin.")
#
#      tag_prefix = rails_env == "production" ? "demo_" : "stable_"
#      run "cd #{shared_path}/#{repository_cache} && git tag|grep #{tag_prefix}| sort | tail -1" do |ssh, stream, data|
#        set :branch, data.chomp
#      end
#    end
#
#    logger.info "setting branch to #{branch}"
#  end

#  task :update_environment_tag, :roles => :app do
#    timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
#    tag_name = "#{rails_env}_#{timestamp}"
#    run <<-CMD
#     cd #{shared_path}/#{repository_cache} &&
#     git tag #{tag_name} &&
#     git push origin #{tag_name}
#    CMD
#    run "echo '#{tag_name}' > #{shared_path}/current_git_version.txt"
#  end
#
#  task :current_tag, :roles => :app do
#    run "cat #{shared_path}/current_git_version.txt"
#  end
#
#end
#before "deploy:update_code", "git_repo:set_the_correct_branch"
#after "deploy:update_code", "git_repo:update_environment_tag"
#
#namespace :mongrel do
#  desc <<-DESC
#  Start Mongrel processes on the app server.  This uses the :use_sudo variable to determine whether to use sudo or not. By default, :use_sudo is
#  set to true.
#  DESC
#  task :start, :roles => :app do
#    if ey
#      sudo "/usr/bin/monit start all -g #{monit_group}"
#    else
#      run "#{deploy_to}/current/config/mongrel/mongrel_cluster restart #{deploy_to}/current/config/mongrel/#{rails_env}"
#    end
#  end
#
#  desc <<-DESC
#  Restart the Mongrel processes on the app server by starting and stopping the cluster. This uses the :use_sudo
#  variable to determine whether to use sudo or not. By default, :use_sudo is set to true.
#  DESC
#  task :restart, :roles => :app do
#    if ey
#      sudo "/usr/bin/monit restart all -g #{monit_group}"
#    else
#      mongrel.start
#    end
#  end
#
#  desc <<-DESC
#  Stop the Mongrel processes on the app server.  This uses the :use_sudo
#  variable to determine whether to use sudo or not. By default, :use_sudo is
#  set to true.
#  DESC
#  task :stop, :roles => :app do
#    if ey
#      sudo "/usr/bin/monit stop all -g #{monit_group}"
#    else
#      run "#{deploy_to}/current/config/mongrel/mongrel_cluster stop #{deploy_to}/current/config/mongrel/#{rails_env}"
#    end
#  end
#end
#
namespace :deploy do
  desc "Run geminstaller"
  task :geminstaller, :roles => [:app] do
    sudo "geminstaller --config #{current_release}/config/geminstaller.yml"
  end
end
#  namespace :from do
#    desc "Deploy from head"
#    task :head do
#
#    end
#  end
#
#  namespace :solr do
#    task :rebuild, :roles => :app do
#      if ey
#        run "cd #{current_release} && ruby script/rebuild_search_index.rb #{rails_env}"
#      else
#        # this is still broken on demo
#      end
#    end
#
#    task :stop, :roles => :app do
#      if ey
#        sudo "monit stop solr"
#      else
#        #        sudo "/etc/init.d/solr stop"
#      end
#    end
#
#    task :start, :roles => :app do
#      if ey
#        sudo "monit start solr"
#      else
#        #        sudo "/etc/init.d/solr start"
#      end
#    end
#
#    task :setup, :roles => :app do
#      on_rollback {
#        sudo "cp -f #{previous_release}/config/solr/#{rails_env}/solr_init.sh /etc/init.d/solr"
#      }
#      sudo "rm -f /etc/init.d/solr"
#      sudo "cp -f #{release_path}/config/solr/#{rails_env}/solr_init.sh /etc/init.d/solr"
#    end
#
#  end
#
#  namespace :monit do
#    task :setup, :roles => :app do
#      if ey
#        on_rollback {
#          sudo "cp -f #{previous_release}/config/monit/#{rails_env}/* /etc/monit.d/"
#        }
#        sudo "cp -f #{release_path}/config/monit/#{rails_env}/* /etc/monit.d/"
#      end
#    end
#  end
#end
#
#task :set_up_document_storage, :roles => :app, :except => {:no_symlink => true} do
#  run "rm -rf #{release_path}/public/documents"
#  run "mkdir -p #{shared_path}/public/documents"
#  run "ln -nfs #{shared_path}/public/documents #{release_path}/public/documents"
#
#  run "mkdir -p #{shared_path}/public/guides_to_thinking"
#  run "ln -nfs #{shared_path}/public/guides_to_thinking #{release_path}/public/guides_to_thinking"
#end
#
## Rails recipes suggest adding the following lines:
## before "deploy:stop", "cron:install"
## after "deploy:start", "cron:uninstall"
## However, there is no need for that, since the current path never changes
## Instead, I've chosen to install it after deploy:cold
## Any time you update the cron file, you can run cap cron:install
#before 'cron:install', 'cron:uninstall'
#
#namespace :cron do
#
#  task :install, :roles => :app do
#    cron_tab = "#{shared_path}/cron.tab"
#    run "mkdir -p #{shared_path}/log/cron"
#    require 'erb'
#    template = File.read("config/templates/cron.erb")
#    file = ERB.new(template).result(binding)
#    put file, cron_tab, :mode => 0644
#    # merge with the current crontab
#    # fails with an empty crontab, which is acceptable
#    run "crontab -l >> #{cron_tab}" rescue nil
#    # install the new crontab
#    run "crontab #{cron_tab}"
#  end
#
#  task :uninstall, :roles => :app do
#    cron_tmp = "#{shared_path}/cron.old"
#    cron_tab = "#{shared_path}/cron.tab"
#    begin
#      # dump the current cron entries
#      run "crontab -l > #{cron_tmp}"
#      # remove any lines that contain the application name
#      run "awk '{if ($0 !~ /#{application}/) print $0}' " +
#      "#{cron_tmp} > #{cron_tab}"
#      # replace the cron entries
#      run "crontab #{cron_tab}"
#    rescue
#      # fails with an empty crontab, which is acceptable
#    end
#    # clean up
#    run "rm -rf #{cron_tmp}"
#  end
#
#end
#after "deploy:cold", "cron:install"
#
## =============================================================================
## Any custom after tasks can go here.
## after "deploy:symlink_configs", "casebook_custom"
## task :casebook_custom, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
##   run <<-CMD
##   CMD
## end
## =============================================================================
#
#before "deploy:symlink", "deploy:solr:setup"
#after "deploy:symlink", "set_up_document_storage"
#after "deploy:symlink", "deploy:monit:setup"
#after "set_up_document_storage", "deploy:solr:stop"
#after "deploy:solr:stop", "deploy:solr:start"
#after "deploy:solr:start", "deploy:solr:rebuild"
#
## Do not change below unless you know what you are doing!
#
#after "deploy", "deploy:cleanup"
#after "deploy:migrations", "deploy:cleanup"
#after "deploy:update_code", "deploy:symlink_configs"
#after "deploy:update_code", "deploy:migrate"
before "deploy:migrate", "deploy:geminstaller"

# uncomment the following to have a database backup done before every migration
# before "deploy:migrate", "db:dump"

