require 'spec_helper'

describe 'hadoop_mapr::hadoop_yarn_resourcemanager' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |_node|
        stub_command(%r{/sys/kernel/mm/(.*)transparent_hugepage/defrag}).and_return(false)
      end.converge(described_recipe)
    end

    it 'installs mapr-resourcemanager package' do
      expect(chef_run).to install_package('mapr-resourcemanager')
    end
  end
end
