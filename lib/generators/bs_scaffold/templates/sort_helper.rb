module SortHelper
  def sort_column key, title, sc, link, context
    sort_by key, 
      title: title, 
      current_column: sc,
      route_method: link,
      class: "onclick #{context} persisted sort",
      data: { collect: ".#{context}.persisted" }
  end

  alias sc sort_column

end
