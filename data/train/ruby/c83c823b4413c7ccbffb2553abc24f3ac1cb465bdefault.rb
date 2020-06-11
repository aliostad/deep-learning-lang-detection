#
# Cookbook Name:: adduser
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
user "test1" do
  comment "test1"
  home "/home/test1"
  shell "/bin/bash"
  password nil
  supports :manage_home => true
  action  [:create, :manage]
end

user "test2" do
  comment "test2"
  home "/home/test2"
  shell "/bin/bash"
  password nil
  supports :manage_home => true
  action  [:create, :manage]
end

user "test3" do
  comment "test3"
  home "/home/test3"
  shell "/bin/bash"
  password nil
  supports :manage_home => true
  action  [:create, :manage]
end