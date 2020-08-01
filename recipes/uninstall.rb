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

    powershell_script 'Uninstall Symantec' do
        code <<-EOH
        MsiExec.exe /X{9E188836-2176-4CA3-B823-C37C84E32E88} /lv!* c:\\uninstallSEP.tx
        EOH
    end

end
