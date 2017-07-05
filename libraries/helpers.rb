#
# Cookbook Name:: hadoop_mapr
# Library:: helpers
#
# Copyright © 2015 Cask Data, Inc.
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

module HadoopMapr
  # Helper methods for hadoop_mapr cookbook
  module Helpers
    #
    # Get the bundled Hadoop version, from /opt/mapr/hadoopversion
    #
    def hadoop_version
      ::File.open('/opt/mapr/hadoop/hadoopversion', 'r').read.strip
    end

    #
    # Get the bundled Hadoop conf directory location
    #
    def hadoop_conf_dir
      "/opt/mapr/hadoop/hadoop-#{hadoop_version}/etc/hadoop" unless hadoop_version.nil?
    end

    #
    # Get the bundled HBase version, from /opt/mapr/hbaseversion
    #
    def hbase_version
      ::File.open('/opt/mapr/hbase/hbaseversion', 'r').read.strip
    end

    #
    # Get the bundled HBase conf directory location
    #
    def hbase_conf_dir
      "/opt/mapr/hbase/hbase-#{hbase_version}/conf" unless hbase_version.nil?
    end

    #
    # Get the bundled Hive conf directory location
    #
    def hive_conf_dir
      result = nil
      # There is no hiveversion file, we can only guess and check
      ::Dir.foreach('/opt/mapr/hive') do |candidate|
        next if candidate == '.' || candidate == '..'
        next unless ::File.directory?(::File.join('/opt/mapr/hive', candidate))
        if ::File.exist?(::File.join('/opt/mapr/hive', candidate, 'conf', 'hive-site.xml'))
          result = ::File.join('/opt/mapr/hive', candidate, 'conf')
          break
        end
      end
      result
    end

    #
    # Get the bundled Hive sql directory location
    #
    def hive_sql_dir
      "#{hive_conf_dir}/../scripts/metastore/upgrade" unless hive_conf_dir.nil?
    end
  end
end

#
# Return true if Kerberos is enabled
#
def hadoop_kerberos?
  node['hadoop']['core_site'].key?('hadoop.security.authorization') &&
    node['hadoop']['core_site'].key?('hadoop.security.authentication') &&
    node['hadoop']['core_site']['hadoop.security.authorization'].to_s == 'true' &&
    node['hadoop']['core_site']['hadoop.security.authentication'] == 'kerberos'
end

#
# Return true if Mapr secure is enabled
#
def mapr_secure?
  node['hadoop_mapr'].key?('gen_keys')
=begin
  node['hadoop']['core_site'].key?('hadoop.security.authorization') &&
    node['hadoop']['core_site'].key?('hadoop.security.authentication') &&
    node['hadoop']['core_site']['hadoop.security.authorization'].to_s == 'true' &&
    node['hadoop']['core_site']['hadoop.security.authentication'] == 'kerberos'
=end
end

def gen_keys?
  node['hadoop_mapr'].key?('gen_keys')
end

# Load helpers
Chef::Recipe.send(:include, ::HadoopMapr::Helpers)
Chef::Resource.send(:include, ::HadoopMapr::Helpers)
