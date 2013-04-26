# Chef-node-capistrano

This repo provides recipes and capistrano tasks to build a node environment quickly.
It uses knife-solo to provision ubuntu LTS 12.10. 

Installs the following packackages using chef.

- Git
- ImageMagick
- Node
- Redis
- Mysql
- SOLR
- mysql-server

It doesn't specifiy any configuration so you might want to add it.

## How to use

Although not necessary the docs here assumate that you have the ``vmware_fusion`` provider of vagrant installed.

### Installing required stuff

You might want to install the following gems since they are required

	gem install capistrano
	gem install railless-deploy		
	gem install knife-solo	
	
### Fowarding SSH if you use github deployment

If your repo is hosted remotely (like on github) you need to setup SSH agent forwarding. Check the link below on how to do this.

[SSH agent forwarding](https://help.github.com/articles/using-ssh-agent-forwarding)
	
### Installing the vagrant box (in case you don't have one yet)
This will download the precise64 box.

	vagrant box add precise64 http://files.vagrantup.com/precise64_vmware.box --provider vmware_fusion
	
Now get ready to initialize and set a new box up.

	vagrant init precise64
	vagrant up --provider vmware_fusion
	
### Configuring your repo 

Go and edit ``config/deploy.rb`` to your environment accordingly.

	set :repository,  "git@github.com:emilebosch/omgponies.git" # your git repo
	set :box, "172.16.50.207"                                   # run 'vagrant ssh-config' for the ip
	set :user, "vagrant"                                        # run 'vagrant ssh-config' for the user
	set :app, "omgponies"                                       # name of your app
	set :dbuser, 'root'                                         # db user
	set :dbpassword, 'iloverandompasswordsbutthiswilldo'        # db pass
	set :dbname, 'omgponies'                                    # db name
	
### Building your local vagrant environment
Then you might want to copy your own public key over to your vagrant machine, cause vagrant uses its own identity file. Which makes using capistrano a pain. 

	cap vagrant:copykey
	
After that you can start installing chef on the vagrant machine. I know vagrant comes with its own provisinging stuff but because i want to have the same workflow locally as the production machines, i use this.

This installs chef (prepare), and updates (cooks) the machine

	cap chef:setup chef:update

After that go and setup cap

	cap deploy:setup
	
Then deploy your code

	cap deploy
	
### Building the production environment

Make sure you install ubuntu with ssh. 
To copy your own public key over to the remote do the following (instead of vagrant:copy_key)

	cap remote:copykey
	
Then the tasks are the same as explained above.