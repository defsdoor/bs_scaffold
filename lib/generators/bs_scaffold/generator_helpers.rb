module BsScaffold
  module Generators
    module GeneratorHelpers
      attr_accessor :options, :attributes

      private

      def model_columns_for_attributes
        class_name.constantize.columns.reject do |column|
          column.name.to_s =~ /^(id|created_at|updated_at)$/
        end
      end

      def editable_attributes
        attributes ||= model_columns_for_attributes.map do |column|
          Rails::Generators::GeneratedAttribute.new(column.name.to_s, column.type.to_s)
        end
      end

      def view_files
        files = %w(create.js.erb
          destroy.js.erb
          _details.html.erb
          edit.js.erb
          _form.html.erb
          _form.js.erb
          _header.html.erb
          index.html.erb
          index.js.erb
          new.js.erb
          _row.html.erb
          _show.html.erb
          show.html.erb
          _show.js.erb
          _table_container.html.erb
          update.js.erb
          _update_row.js.erb
          _update_show.js.erb)
      end

    end
  end
end
