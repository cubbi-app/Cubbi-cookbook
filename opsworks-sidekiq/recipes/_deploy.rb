# Adapted from deploy::rails: https://github.com/aws/opsworks-cookbooks/blob/master/deploy/recipes/rails.rb

include_recipe 'deploy'

node[:deploy].each do |application, deploy|
<<<<<<< HEAD

  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping opsworks_sidekiq::deploy application #{application} as it is not an Rails app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  include_recipe "opsworks_sidekiq::setup"

  template "#{deploy[:deploy_to]}/shared/config/memcached.yml" do
    cookbook "rails"
    source "memcached.yml.erb"
    mode 0660
    owner deploy[:user]
    group deploy[:group]
    variables(:memcached => (deploy[:memcached] || {}), :environment => deploy[:rails_env])
  end

  node.set[:opsworks][:rails_stack][:restart_command] = node[:sidekiq][application][:restart_command]

  opsworks_deploy do
    deploy_data deploy
    app application
=======
  if deploy['sidekiq']
    sidekiq_config = deploy['sidekiq']
    release_path = ::File.join(deploy[:deploy_to], 'current')
    start_command = sidekiq_config['start_command'] || "bundle exec sidekiq -e #{deploy[:rails_env]} -C config/sidekiq.yml -r ./config/boot.rb 2>&1 >> log/sidekiq.log"
    env = deploy['environment_variables'] || {}

    template "setup sidekiq.conf" do
      path "/etc/init/sidekiq-#{application}.conf"
      source "sidekiq.conf.erb"
      owner "root"
      group "root"
      mode 0644
      variables({
        app_name: application,
        user: deploy[:user],
        group: deploy[:group],
        release_path: release_path,
        start_command: start_command,
        env: env,
      })
    end

    service "sidekiq-#{application}" do
      provider Chef::Provider::Service::Upstart
      supports stop: true, start: true, restart: true, status: true
    end

    # always restart sidekiq on deploy since we assume the code must need to be reloaded
    bash 'restart_sidekiq' do
      code "echo noop"
      notifies :restart, "service[sidekiq-#{application}]"
    end
>>>>>>> afcf18a9bbf01e5131321c5a807e1a1858f1b4d2
  end
end
