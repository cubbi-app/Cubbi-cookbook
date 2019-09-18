node[:deploy].each do |application, deploy|
  rails_master_key = deploy[:rails_master_key]

  Chef::Log.info("create master key for #{rails_env}")
  
  execute 'create_master_key' do
    cwd current_path
    user 'deploy'
    command "echo #{rails_master_key} > /config/credentials/#{rails_env}.key"
  end
end
