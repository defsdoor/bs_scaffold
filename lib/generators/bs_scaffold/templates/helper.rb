module <%= class_name.pluralize %>Helper
  def <%= plural_table_name %>_sort_link
    @link ||= lambda { |params| <%= plural_table_name %>_path( params ) }
  end

  def <%= plural_table_name %>_next_page ( <%= plural_table_name %> )
    return <%= plural_table_name %>_path( <%= plural_table_name %>_safe_params(params).merge page: <%= plural_table_name %>.next_page ) if <%= plural_table_name %>.next_page
  end

  def <%= plural_table_name %>_safe_params(p)
    p.permit(:sort, :direction, :search)
  end

end
