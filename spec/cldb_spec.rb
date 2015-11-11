require 'spec_helper'

describe 'hadoop_mapr::cldb' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6).converge(described_recipe)
    end

    it 'installs mapr-cldb package' do
      expect(chef_run).to install_package('mapr-cldb')
    end
  end
end
