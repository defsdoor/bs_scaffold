require 'generators/bs_scaffold/generator_helpers'

module BsScaffold
  module Generators
    # Custom scaffolding generator
    class ControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      include BsScaffold::Generators::GeneratorHelpers

      desc "Generates controller, controller_spec and views for the model with the given NAME"

      source_root File.expand_path('../templates', __FILE__)

      class_option :orm, banner: "NAME", type: :string, required: true,
                         desc: "ORM to generate the controller for"


      def copy_controller_and_spec_files
        template "controller.rb", File.join( "app/controllers", "#{controller_file_name}_controller.rb")
      end

      def copy_presenter
        template "presenter.rb", File.join( "app/presenters", "#{singular_table_name}_presenter.rb")
      end

      def copy_helper
        template "helper.rb", File.join( "app/helpers", "#{plural_table_name}_helper.rb")
      end

      def add_route
        route "resources :#{plural_table_name}"
      end

      def copy_view_files
        directory_path = File.join('app/views', controller_file_path)
        empty_directory directory_path

        view_files.each do |file_name|
          template "views/#{file_name}", File.join(directory_path, "#{file_name}")
        end
      end
    end
  end
end
