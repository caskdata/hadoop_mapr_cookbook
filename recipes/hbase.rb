#
# Cookbook Name:: hadoop_mapr
# Recipe:: hbase
#
# Copyright © 2013-2015 Cask Data, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Ensure conf directory exists
package 'mapr-hbase' do
  action :install
  version node['hbase']['version'] if node['hbase'].key?('version') && !node['hbase']['version'].empty?
end

template 'hbase-site.xml' do
  path lazy { "#{hbase_conf_dir}/hbase-site.xml" }
  source 'generic-site.xml.erb'
  mode '0644'
  owner 'root'
  group 'root'
  action :create
  variables options: node['hbase']['hbase_site']
  only_if { node['hbase'].key?('hbase_site') && !node['hbase']['hbase_site'].empty? }
end
