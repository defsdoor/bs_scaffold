module <%= class_name.pluralize %>Helper
  def sort_link
    @link ||= lambda { |params| <%= plural_table_name %>_path( params ) }
  end

  def next_page ( <%= plural_table_name %> )
    return <%= plural_table_name %>_path( safe_params(params).merge page: <%= plural_table_name %>.next_page ) if <%= plural_table_name %>.next_page
  end

  def safe_params(p)
    p.permit(:sort, :direction, :search)
  end

end
