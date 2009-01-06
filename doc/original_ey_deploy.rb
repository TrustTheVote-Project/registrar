# Please install the Engine Yard Capistrano gem
# gem install eycap --source http://gems.engineyard.com

require "eycap/recipes"

# =============================================================================
# ENGINE YARD REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The :deploy_to variable must be the root of the application.

set :keep_releases,       5
set :application,         "project-uc"
set :user,                "pivotal"
set :password,            "o25o4v11j1"
set :deploy_to,           "/data/#{application}"
set :monit_group,         "project-uc"
set :runner,			  "pivotal"
set :repository,          "https://svn.pivotallabs.com/subversion/cookstr/trunk"
set :scm_username,        "engineyard"
set :scm_password,        "rich7focus"
set :scm,                 :subversion
set :deploy_via,          :filtered_remote_cache
set :repository_cache,    "/var/cache/engineyard/#{application}"
set :production_database, "project-uc_production"
set :production_dbhost,   "ey04-s00294"
set :staging_database,    "project-uc_staging"
set :staging_dbhost,      "ey04-s00294"
set :dbuser,              "pivotal_db"
set :dbpass,              "wk2ekjb1k2"

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.
task :production do
  role :web, "65.74.186.4:8291" # project-uc [mongrel,solr] [ey04-s00294]
  role :app, "65.74.186.4:8291", :mongrel => true, :solr => true
  role :db , "65.74.186.4:8291", :primary => true
  role :app, "65.74.186.4:8292", :no_release => true, :no_symlink => true, :mongrel => true
  
  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end
  
task :staging do
  role :web, "65.74.186.4:8047" # project-uc [mongrel,solr] [ey04-s00294]
  role :app, "65.74.186.4:8047", :mongrel => true, :solr => true
  role :db , "65.74.186.4:8047", :primary => true
  
  set :rails_env, "staging"
  set :environment_database, defer { staging_database }
  set :environment_dbhost, defer { staging_dbhost }
end

# =============================================================================
# Any custom after tasks can go here.
# after "deploy:symlink_configs", "project-uc_custom"
# task :project-uc_custom, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
#   run <<-CMD
#   CMD
# end
# =============================================================================

# Do not change below unless you know what you are doing!

after "deploy", "deploy:cleanup"
after "deploy:migrations" , "deploy:cleanup"
after "deploy:update_code", "deploy:symlink_configs"
after "deploy:symlink_configs", "solr:symlink_configs"

# uncomment the following to have a database backup done before every migration
# before "deploy:migrate", "db:dump"

