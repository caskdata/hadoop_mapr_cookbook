#
# Cookbook Name:: hadoop_mapr
# Recipe:: _system_tuning
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

# System tunings per http://doc.mapr.com/display/MapR/Preparing+Each+Node

# Disable SELinux
include_recipe 'selinux::disabled'

# Ensure ulimit pam.d/su configuration
include_recipe 'ulimit::default'

include_recipe 'sysctl::default'

# Disable overcommit
sysctl_param 'vm.overcommit_memory' do
  value 0
end

# Disable swapping
sysctl_param 'vm.swappiness' do
  value 0
end

# reduce TCP retries so that MapR can detect unreachable nodes with less latency
sysctl_param 'net.ipv4.tcp_retries2' do
  value 5
end

# Disable transparent_hugepages compaction
# Note, MapR documentation is inconsistent whether to disable THP compaction or THP altogether
# COOK-57 location can vary within CentOS
%w[transparent_hugepage redhat_transparent_hugepage].each do |dir|
  thp_defrag = "/sys/kernel/mm/#{dir}/defrag"
  next unless ::File.file?(thp_defrag)

  # disable transparent_hugepage (if not already disabled)
  execute 'disable-transparent-hugepage-compaction' do
    command "echo never > #{thp_defrag}"
    not_if "grep '\\[never\\]' #{thp_defrag}"
  end
  break
end
