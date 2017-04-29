class Doorkeeper::ModelsGenerator < ::Rails::Generators::Base
  desc 'Installs Doorkeeper model files.'

  source_root File.expand_path('../templates/models', __FILE__)

  def install
    template 'access_grant.rb.erb', 'app/models/access_grant.rb'
    template 'access_token.rb.erb', 'app/models/access_token.rb'
    template 'application.rb.erb', 'app/models/application.rb'
    template 'user.rb.erb', 'app/models/user.rb'
  end
end
