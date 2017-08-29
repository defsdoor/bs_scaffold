<% if namespaced? -%>
     require_dependency "<%= namespace_path %>/application_controller"
<% end -%>

<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :get_<%= plural_table_name %>, only: [:index]
  before_action :get_<%= singular_table_name %>, except: [:new, :create, :index]

  respond_to :html, :js

  def index
  end

  def show
  end

  def edit
  end

  def update
    @<%= orm_instance.update( "#{singular_table_name}_params" ) %>
  end

  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end

  def create
    @<%= singular_table_name %> = <%= class_name %>.create( <%= singular_table_name %>_params )
  end

  def destroy
    @<%= singular_table_name %>.destroy
    respond_with @<%= singular_table_name %>
  end

  private

  def get_<%= singular_table_name %>
    @<%= singular_table_name %> = <%= orm_class.find( class_name, "params[:id]" ) %>
  end

  def get_<%= plural_table_name %>
    @<%= plural_table_name %> = <%= class_name %>.order( <%= singular_table_name %>_sort_column.order )
      .page(params[:page]).per(100)
    @<%= plural_table_name %> = @<%= plural_table_name %>.where( search_condition ) unless params[:search].blank?
  end

  def search_condition 
    s = params[:search]
    [ '<%= editable_attributes.map {  |a| "#{a.name} LIKE ?" }.join(' OR ')%>', <%= Array.new(editable_attributes.map.size, '"%#{s}%"').join(', ') %>]
  end

  def <%= "#{singular_table_name}_params" %>
    params.require(:<%= singular_table_name %>).permit(<%= editable_attributes.map { |a| ":#{a.name}" }.join(', ') %>)
  end

  def <%= singular_table_name %>_sort_column
    @sort_column ||=
      SortableTable::SortTable.new( [
        <%= editable_attributes.map { |a|
          "SortableTable::SortColumnDefinition.new('#{a.name}')"
        }.join(",\n          ") %>
      ]).sort_column( params[:sort], params[:direction] )
  end


end
<% end -%>
