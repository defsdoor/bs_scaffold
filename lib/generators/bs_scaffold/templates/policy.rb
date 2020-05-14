<% if namespaced? -%>
     require_dependency "<%= namespace_path %>/application_controller"
<% end -%>

<% module_namespacing do -%>
class <%= class_name %>Policy < ApplicationPolicy
  private

  def right_name
    "<%= class_name.underscore %>"
  end

end
<% end -%>
