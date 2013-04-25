run_list \
	"recipe[git]",
	"recipe[sunspot]",
	"recipe[nodejs::install_from_binary]",
	"recipe[sunspot]",
	"recipe[imagemagick]",
	"recipe[mysql::server]",
	"recipe[mysql::client]",
	"recipe[redis]"