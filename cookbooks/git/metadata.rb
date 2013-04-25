name              "git"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs git and/or sets up a Git server daemon"
version           "2.5.0"
recipe            "git", "Installs git"

%w{ amazon arch centos debian fedora redhat scientific oracle amazon ubuntu windows }.each do |os|
  supports os
end

supports "mac_os_x", ">= 10.6.0"

attribute "git/server/base_path",
  :display_name => "Git Daemon Base Path",
  :description => "A directory containing git repositories to be exposed by the git-daemon",
  :default => "/srv/git",
  :recipes => ["git::server"]

attribute "git/server/export_all",
  :display_name => "Git Daemon Export All",
  :description => "Adds the --export-all option to the git-daemon parameters, making all repositories publicly readable even if they lack the \"git-daemon-export-ok\" file",
  :choice => ["true", "false"],
  :default => "true",
  :recipes => ["git::server"]