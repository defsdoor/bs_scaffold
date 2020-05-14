require 'generators/bs_scaffold/generator_helpers'

module BsScaffold
  module Generators
    # Custom scaffolding generator
    class InstallGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      include BsScaffold::Generators::GeneratorHelpers

      desc "Generates install requirements for bs_scaffold controller generator"

      source_root File.expand_path('../templates', __FILE__)

      def update_gemfile
        gem 'jquery-rails'
        gem 'jquery-ui-rails'
        gem 'simple_form'
        gem 'bootstrap', version: '~> 4.0.0.alpha6'
        gem 'sortable-table', github: 'defsdoor/sortable-table'
        gem 'kaminari'
        gem 'responders', version: '~> 2.0'
        gem 'fontello_rails_converter', group: :development
        gem 'pundit'
      end

      def copy_presenter
        template "base_presenter.rb", "app/presenters/base_presenter.rb"
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

    end
  end
end
