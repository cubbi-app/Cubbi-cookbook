node[:deploy].each do |application, deploy|
  rails_env = deploy[:rails_env]
  current_path = deploy[:current_path]

  Chef::Log.info("Precompiling Rails assets with environment #{rails_env}")

  execute 'rake assets:precompile' do
    cwd current_path
    user 'deploy'
    command "SECRET_KEY_BASE=`bundle exec rake assets:precompile RAILS_ENV=#{rails_env}"
    environment 'RAILS_ENV' => rails_env
  end
end
