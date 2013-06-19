x1# Chef-node-capistrano

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

Go and edit ``config/deploy.rb`` to your project accordingly.

	set :repository,  "git@github.com:emilebosch/omgponies.git" # your git repo
	set :box, "172.16.50.207"                                   # run 'vagrant ssh-config' for the ip
	set :user, "vagrant"                                        # run 'vagrant ssh-config' for the user
	set :app, "omgponies"                                       # name of your app
	set :dbuser, 'root'                                         # db user
	set :dbpassword, 'iloverandompasswordsbutthiswilldo'        # db pass
	set :dbname, 'omgponies'                                    # db name

### Bootstrap your remote machine.

After a clean install (i used UBUNTU LTS 10.3), its neccessary to bootstrap your machine. This copies your `~/.ssh/id_rsa.pub` to the
remote machine. Sets up passwordless SUDO, and removes password login so you can only access your machine only with your own private key.

It will ask for your SUDO password twice, and then you're good to go for the remaining of the installation.

	cap remote:bootstrap

After that, you can start setting up chef. This installs chef (prepare), and updates (cooks) the machine.

	cap chef:setup chef:update

After that go and setup capistrano, so you can do your github deploys

	cap deploy:setup

Then deploy your code

	cap deploy