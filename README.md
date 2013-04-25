# Chef-node-capistrano

This repo provides recipes and capistrano tasks to build a node environment quickly.
It uses knife-solo to provision ubuntu LTS 12.10. 

It asumes you have the vmware_fusion provider of vagrant. 

Installs the following packackages using chef.

- ImageMagick
- Node
- Redis
- Mysql
- SOLR
- mysql-server

It doesn't specifiy any configuration so you might want to add it.

## How to use

### Installing required stuff

You might want to install the following gems since they are required

	gem install capistrano
	gem install railless-deploy		
	gem install knife-solo
	
### Configuring your repo 

Go and edit ``config/deploy.rb`` put in your settings.


	set :repository,  "git@github.com:emilebosch/omgponies.io.git"
	set :box, "172.16.50.207"
	set :user, "vagrant"
	set :app, "omgponies"
	set :dbuser, 'root' #loljustkidding
	set :dbpassword, 'iloverandompasswordsbutthiswilldo' #best password evah
	set :dbname, 'omgponies'
	
### Building your local vagrant environment
	
After this you can create your vagrant machine like this.

	vagrant up --provider vmware_fusion 

Then you might want to copy your own public key over to your vagrant machine, cause vagrant uses its own identity file. Which makes using capistrano a pain. 

	cap vagrant:setup
	
After that you can start installing chef on the vagrant machine. I know vagrant comes with its own provisinging stuff but because i want to have the same workflow locally as the production machines, i use this.

This installs chef (prepare), and updates (cooks) the machine

	cap chef:setup chef:update

After that go and setup cap

	cap deploy:setup
	
Then deploy your code

	cap cap:deploy
	

