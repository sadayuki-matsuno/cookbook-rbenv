
# cent-os install package
default[:rbenv][:common][:package] = ["make", "gcc"]
default[:rbenv][:centos][:package] = ["openssl-devel", "readline-devel"]
default[:rbenv][:ubuntu][:package] = ["libssl-dev", "libreadline6-dev"]

# rbenv設定
default[:rbenv][:user]           = "rbenv"
default[:rbenv][:group]          = "rbenv"
default[:rbenv][:group_users]    = Array.new
default[:rbenv][:path]           = "/usr/local/rbenv"
default[:rbenv][:git_repository] = "https://github.com/sstephenson/rbenv.git"
default[:rbenv][:git_revision]   = "master"
default[:rbenv][:root]           = default[:rbenv][:path]


# rbenv git設定
default[:rbenv_git][:directory][:shims]      = "#{default[:rbenv][:root]}/shims"
default[:rbenv_git][:directory][:versions]   = "#{default[:rbenv][:root]}/versions"
default[:rbenv_git][:directory][:plugins]    = "#{default[:rbenv][:root]}/plugins"
default[:rbenv_git][:mode]                   = "2775"


# ruby-buiild設定
default[:ruby_build][:git_repository] = "https://github.com/sstephenson/ruby-build.git"
default[:ruby_build][:git_revision]   = "master"
default[:ruby_build][:path]           = "/usr/local/ruby-build"
default[:ruby_build][:bin_path]       = "#{default[:rbenv][:root]}/bin"
default[:ruby_build][:mode]           = "2775"

# ruby設定
default[:ruby][:version]   = "2.1.4"
default[:ruby][:install]   = "rbenv install #{default[:ruby][:version]}"
default[:ruby][:global]    = "rbenv global #{default[:ruby][:version]}"
default[:ruby][:whether_exist_version] = "/usr/local/rbenv/versions/#{default[:ruby][:version]}"

# bash設定
default[:rbenv_sh][:filename]       = "rbenv.sh.erb"
default[:rbenv_sh][:path]           = "/etc/profile.d/rbenv.sh"
default[:rbenv_sh][:mode]           = "0644"
default[:rbenv_sh][:reload_command] = "source #{default[:rbenv_sh][:path]}"
default[:rbenv_sh][:env_set]        = "#{default[:rbenv][:root]}/bin:#{default[:rbenv][:root]}/shims:#{default[:ruby_build][:bin_path]}"


