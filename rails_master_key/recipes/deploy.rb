node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]
  rails_master_key = node[:deploy][application][:environment]["RAILS_MASTER_KEY"]
  
  Chef::Log.info("create master key for #{rails_env}")
  
  execute 'create_master_key' do
    user 'deploy'
    command "mkdir -p #{current_path}/config/credentials && echo #{rails_master_key} > #{current_path}/config/credentials/#{rails_env}.key"
  end
end
