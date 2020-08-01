#
# Cookbook:: symantec
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
case node['os']
when 'linux'

    os_version = `cat /etc/*-release`
    kernel_version = `rpm -qa |grep kernel-[0-9] |cut -c8-`
    kernel_version.delete!("\n")
    package "kernel-headers-#{kernel_version}"
    package "kernel-devel-#{kernel_version}"
    package "unzip"
    package "glibc.i686"
    #package "libgcc.i686"
   
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
        sudo ./install.sh -i
       EOH
    end

    bash 'Verify Symantec' do
      code <<-EOH
        cd /opt/Symantec/symantec_antivirus
        ./sav info -p
      EOH
    end


when 'windows'

    remote_file "c:/sepsetup64.exe" do
        source "https://chef-apac.s3-ap-southeast-1.amazonaws.com/setup64.exe"
    end

    powershell_script 'Install Symantec' do
        code "c:\\sepsetup64.exe"
    end


end