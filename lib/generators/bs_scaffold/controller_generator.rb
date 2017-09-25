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


      def update_gemfile
        gem 'jquery-rails'
        gem 'jquery-ui-rails'
        gem 'simple_form'
        gem 'bootstrap', version: '~> 4.0.0.alpha6'
        gem 'sortable-table', github: 'defsdoor/sortable-table'
        gem 'kaminari'
        gem 'responders', version: '~> 2.0'
        gem 'fontello_rails_converter', group: :development
      end


      def copy_controller_and_spec_files
        template "controller.rb", File.join( "app/controllers", "#{controller_file_name}_controller.rb")
      end

      def copy_presenter
        template "base_presenter.rb", "app/presenters/base_presenter.rb"
        template "presenter.rb", File.join( "app/presenters", "#{singular_table_name}_presenter.rb")
      end

      def copy_assets
        template "extensions.js", "app/assets/javascripts/extensions.js"
        template "startup.js", "app/assets/javascripts/startup.js"
        template "styles.css.scss", "app/assets/stylesheets/styles.css.scss"
        template "fontello-extensions.scss", "app/assets/stylesheets/fontello-extensions.scss"
        template "sortable_columns.scss", "app/assets/stylesheets/sortable_columns.scss"

        template "_bootstrap_helper.html.erb", "app/views/common/_bootstrap_helper.html.erb"
        template "_flash.js.erb", "app/views/common/_flash.js.erb"
        template "_flash_only.js.erb", "app/views/common/_flash_only.js.erb"
        template "_modal.html.erb", "app/views/common/_modal.html.erb"
      end

      def copy_helper
        template "helper.rb", File.join( "app/helpers", "#{plural_table_name}_helper.rb")
        template "sort_helper.rb", "app/helpers/sort_helper.rb"
        template "bootstrap_helper.rb", "app/helpers/bootstrap_helper.rb"
        template "icons_helper.rb", "app/helpers/icons_helper.rb"
        template "flash_helper.rb", "app/helpers/flash_helper.rb"
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
