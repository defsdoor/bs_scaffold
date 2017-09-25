module FlashHelper

  def insert_flash
    content_tag :div, id: 'flash', class: 'flash' do
      flash_messages
    end
  end

  def flash_messages(hide=false)
    s=""
    flash.each do |name, msg|
      s << add_flash( name, msg, hide) unless name == "html_safe"
    end unless flash.empty?
    s.html_safe
  end

  private

  def add_flash(name, msg, hide)
    res=""
    if msg.is_a?(Array)
      msg.each do |m|
        res << flash_div(name, m, hide)
      end
    else
      res = flash_div(name, msg, hide)
    end
    res.html_safe
  end

  def flash_div(name, msg, hide)
    # content_tag(:div, class: "alert alert-#{ flash_type_to_bootstrap(name) }", style: "display: none;") do
    content_tag(:div, class: "alert alert-#{ flash_type_to_bootstrap(name) }") do
      button_tag("&times;".html_safe, class: "close", "aria-hidden" => true, "data-dismiss" => "alert") +
      content_tag( :div, msg )
    end
  end

  def flash_type_to_bootstrap(s)
    { "notice" => "info", "alert" => "warning", "warn" => "danger", "error" => "danger"}[s] || s
  end

end
