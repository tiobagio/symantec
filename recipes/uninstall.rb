#
# Cookbook:: symantec
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
case node['os']
when 'linux'
   
    # cp SymantecEndpointProtection.zip file to /tmp/sep
    remote_file "/tmp/SymantecEndpointProtection.zip" do
        source "https://chef-apac.s3-ap-southeast-1.amazonaws.com/SymantecEndpointProtection_14.3_rpm.zip"
    end

    bash 'Install Symantec' do
       code <<-EOH
        mkdir -p /tmp/sep
        cd /tmp/sep
        sudo unzip -d . /tmp/SymantecEndpointProtection.zip
    
        sudo chmod 777 install.sh pkg.sig 
        sudo ./install.sh -u
       EOH
    end

when 'windows'

    remote_file "c:/sepsetup64.exe" do
        source "https://chef-apac.s3-ap-southeast-1.amazonaws.com/setup64.exe"
    end

    powershell_script 'Install Symantec' do
        code <<-EOH
        c:\\setup64.exe
        EOH
    end

end