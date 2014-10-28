#
# Cookbook Name:: rbenv
# Recipe:: node
#
# Copyright 2014, Future Architect
#
# All rights reserved - Do Not Redistribute
#


# install packages
node[:rbenv][:cent_os][:package].each do |pack|
  package pack do
    action :install
  end
end

# create group
create_group = group node[:rbenv][:group] do
  members node[:rbenv][:group_users] if node[:rbenv][:group_users]
  action :nothing
end

# creaate user
create_user = user node[:rbenv][:user] do
  shell "/bin/bash"
  group node[:rbenv][:group]
  action :nothing
end

# make directory rbenv 
make_directory_of_rbenv = directory node[:rbenv][:path] do
  owner node[:rbenv][:user]
  group node[:rbenv][:group]
  mode node[:rbenv_git][:mode]
  recursive true
  action :nothing
end

# make directory ruby-build
make_directory_of_ruby_build = directory node[:ruby_build][:path] do
  owner node[:rbenv][:user]
  group node[:rbenv][:group]
  mode node[:ruby_build][:mode] 
  recursive true
  action :nothing
end


# git clone rbenv
git_clone_rbenv = git node[:rbenv][:path] do
  repository node[:rbenv][:git_repository]
  reference node[:rbenv][:git_revision]
  user node[:rbenv][:user]
  group node[:rbenv][:group]
  action :nothing
end

# make directory
make_directory_of_shims = directory node[:rbenv_git][:directory][:shims]  do
  owner node[:rbenv][:user]
  group node[:rbenv][:group]
  mode node[:rbenv_git][:mode]
  action [:nothing]
end

make_directory_of_versions = directory node[:rbenv_git][:directory][:versions]  do
  owner node[:rbenv][:user]
  group node[:rbenv][:group]
  mode node[:rbenv_git][:mode]
  action [:nothing]
end

make_directory_of_plugins = directory node[:rbenv_git][:directory][:plugins]  do
  owner node[:rbenv][:user]
  group node[:rbenv][:group]
  mode node[:rbenv_git][:mode]
  action [:nothing]
end

# git clone ruby-build
git_clone_ruby_build = git node[:ruby_build][:path] do
  repository node[:ruby_build][:git_repository]
  reference node[:ruby_build][:git_revision]
  user node[:rbenv][:user]
  group node[:rbenv][:group]
  action :nothing
end

# set the  path to rbenv in bash 
set_the_path_to_rbenv_in_bash = template node[:rbenv_sh][:path] do
  source node[:rbenv_sh][:filename]  
  mode node[:rbenv_sh][:mode]
  variables(
    :rbenv_root => node[:rbenv][:root],
    :ruby_build_bin_path => node[:ruby_build][:bin_path]
  )
  action :nothing 
end

# restart shell
restart_shell = bash "restart shell" do
  code node[:rbenv_sh][:reload_command]
  action :nothing
end

initialize_rbenv = ruby_block "initialize_rbenv" do
  block do
    ENV['RBENV_ROOT'] = node[:rbenv][:root]
    ENV['PATH'] = "#{node[:rbenv_sh][:env_set]}:#{ENV['PATH']}"
  end
  action :nothing
end





# install.sh 
install_sh = bash "install.sh" do
  code "#{node[:ruby_build][:path]}/install.sh"
  action :nothing
end
 
# ruby install
ruby_install = bash "ruby install" do
    code node[:ruby][:install]
    action :nothing
end

# ruby global 
ruby_global = bash "ruby global" do
    code node[:ruby][:global]
    action :nothing
end

# rbenv rehash
rbenv_rehash = bash "rbenv rehash" do
    code "rbenv rehash"
    action :nothing
end

# gem install rehsh
# install to ruby in chef
gem_install_rehash = gem_package "rbenv-rehash" do
  action :nothing
end


# execute chef
ruby_block "execute_chef" do
  block do
    create_group.run_action(:create)
    create_user.run_action(:create)
    make_directory_of_rbenv.run_action(:create)
    make_directory_of_ruby_build.run_action(:create)
    git_clone_rbenv.run_action(:sync)
    make_directory_of_shims.run_action(:create)
    make_directory_of_versions.run_action(:create)
    make_directory_of_plugins.run_action(:create)
    git_clone_ruby_build.run_action(:sync)
    set_the_path_to_rbenv_in_bash.run_action(:create_if_missing)
    restart_shell.run_action(:run)
    initialize_rbenv.run_action(:run)
    install_sh.run_action(:run)
    ruby_install.run_action(:run)
    ruby_global.run_action(:run)
    rbenv_rehash.run_action(:run)
    gem_install_rehash.run_action(:install)
  end
  action :run
end


