namespace :artifact do

  def strategy
    @strategy ||= Capistrano::Artifact.new(self, fetch(:artifact_strategy, Capistrano::Artifact::DefaultStrategy))
  end

  desc "Check that artifact exists"
  task :check do
    strategy.check
  end

  desc 'Copy repo to releases'
  task :create_release do
    on release_roles :all do
      execute :mkdir, '-p', release_path
      execute "curl --silent '#{strategy.asset_url(strategy.region)}' | tar --strip 1 -C #{release_path} -zxf -"
    end
  end

  desc 'Set current revision'
  task :set_current_revision do
    set :current_revision, fetch(:artifact_version)
  end
end

