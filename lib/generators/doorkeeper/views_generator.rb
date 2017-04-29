module Doorkeeper
  module Generators
    class ViewsGenerator < ::Rails::Generators::Base
      desc 'Copies default Doorkeeper views and layouts to your application.'

      source_root File.expand_path('../../../../app/views', __FILE__)

      def views
        directory 'doorkeeper', 'app/views/doorkeeper'
        directory 'layouts/doorkeeper', 'app/views/layouts/doorkeeper'
      end
    end
  end
end
