node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]
  rails_master_key = deploy[:rails_master_key]

  Chef::Log.info("create master key for #{rails_env}")
  
  execute 'create_master_key' do
    cwd current_path
    user 'deploy'
    command "echo #{rails_master_key} > /config/credentials/#{rails_env}.key"
  end
  
  Chef::Log.info("Precompiling Rails assets with environment #{rails_env}")

  execute 'rake assets:precompile' do
    cwd current_path
    user 'deploy'
    command "bundle exec rake assets:precompile RAILS_ENV=#{rails_env}"
    environment 'RAILS_ENV' => rails_env
  end
  
end
