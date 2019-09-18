node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]
  rails_master_key = application.to_h.to_s
  
  Chef::Log.info("create master key for #{rails_env}")
  
  execute 'create_master_key' do
    user 'deploy'
    command "echo #{rails_master_key} > #{current_path}/config/credentials/#{rails_env}.key"
  end
end
