require 'railsless-deploy'
load 'deploy'
load 'config/deploy'

role :app, box
set :deploy_via, :remote_cache
set :copy_exclude, ['.git']
set :ssh_options, { :forward_agent => true }
set :normalize_asset_timestamps, false
set :scm, :git
set :use_sudo, false
set :deploy_to, "~/apps/#{app}"

task :web do
	system "open http://#{box}:3000"
end

task :ssh do
	system "ssh #{user}@#{box}"
end

after "deploy:setup" do
	# fix user rights & add github known hosts & make node modules cache
	top.run "chown -R #{user} #{deploy_to} && chgrp -R #{user} #{deploy_to}"
	top.run "mkdir -p #{deploy_to}/shared/node_modules"
	top.run "ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts"
end

after "deploy:create_symlink" do
	top.run "cd #{deploy_to}/current && ln -s #{deploy_to}/shared/node_modules && npm install"
end

namespace :vagrant do
	desc 'Copies the key ~/.ssh/id_rsa.pub to the vagrant box.'
	task :setup do
		# vagrant uses an identify file which means its impossibru for us to easy ssh into vagrant, therefore
		# copy our key over
		system "cat ~/.ssh/id_rsa.pub | ssh -i ~/.vagrant.d/insecure_private_key #{user}@#{box} 'cat >> ~/.ssh/authorized_keys'"
	end
end

namespace :remote do
	desc 'Copies the key to the  ~/.ssh/id_rsa.pub remote box.'
	task :setup do
		# vagrant uses an identify file which means its impossibru for us to easy ssh into vagrant, therefore
		# copy our key over
		system "cat ~/.ssh/id_rsa.pub | ssh #{user}@#{box} 'mkdir -p ~/.ssh/ && cat >> ~/.ssh/authorized_keys'"
	end
end

namespace :db do
	desc 'Populate the database.'
	task :create do
		top.run "cd #{deploy_to}/current && mysql -u#{dbuser} -p#{dbpassword} -e 'create database if not exists #{dbname}' && mysql -u#{dbuser} -p#{dbpassword} #{dbname} < sql/latest.sql"
	end
end

namespace :chef do
	desc 'Setup chef via knife solo prepare.'
	task :setup do
		system "knife solo prepare #{user}@#{box} ./nodes/local.json"
	end
	desc 'Update chef via knife solo cook.'
	task :update do
		system "knife solo cook #{user}@#{box} ./nodes/local.json"
	end
end

namespace :node do
	desc 'Starts the node server.'
	task :start do
		top.run "cd #{deploy_to}/current && NODE_ENV=production nohup node web.js > /dev/null 2>&1 &"
	end
	desc 'Stops the node server.'
	task :stop, :on_error => :continue do
		top.run 'killall node'
	end
	desc 'Restart the node server.'
	task :restart do
		node.stop
		node.start
	end
end

after 'deploy:restart' do
	node.restart
end

## Monkey patch

namespace :deploy do
	task :finalize_update, :except => { :no_release => true } do
	    escaped_release = latest_release
	    commands = []
	    commands << "chmod -R -- g+w #{escaped_release}" if fetch(:group_writable, true)
	    shared_children.map do |dir|
	      d = dir.shellescape
	      if (dir.rindex('/')) then
	        commands += ["rm -rf -- #{escaped_release}/#{d}",
	        	"mkdir -p -- #{escaped_release}/#{dir.slice(0..(dir.rindex('/'))).shellescape}"]
	      else
	        commands << "rm -rf -- #{escaped_release}/#{d}"
	      end
	      commands << "ln -s -- #{shared_path}/#{dir.split('/').last.shellescape} #{escaped_release}/#{d}"
	    end
	    run commands.join(' && ') if commands.any?
	  end
end

%w{ deploy:restart deploy:migrate deploy:update deploy:update_code deploy:cold deploy:start deploy:migrations deploy:symlink deploy:stop deploy:create_symlink }.each do |name|
  find_task(name).instance_variable_get(:@desc).insert(0, '[internal]')
end