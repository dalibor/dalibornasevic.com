require 'gitploy/script'

configure do |c|
  stage :production do
    c.path = '/home/deployer/www/dalibornasevic.com'
    c.host = '192.241.242.98'
    c.user = 'deployer'
  end
end

setup do
  remote do
    run "mkdir -p #{config.path}"
    run "cd #{config.path} && git init"
    run "git config --bool receive.denyNonFastForwards false"
    run "git config receive.denyCurrentBranch ignore"
  end
end

deploy do
  push!
  # when you need to force push
  # local { run "git push #{config.user}@#{config.host}:#{config.path}/.git #{config.local_branch}:#{config.remote_branch} -f" }
  remote do
    run "cd #{config.path}"
    run "git reset --hard"
    run "ruby -v"
    run "bundle install"
    run "bundle exec rake assets:precompile"
    run "bundle exec rake posts:cache"
    run "touch tmp/restart.txt"
  end
end

