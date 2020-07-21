module IconsHelper

  def icon( icon, *options )
    image_html = content_tag( :svg ) do
        "<use xlink:href=\"#icon-#{icon.to_s.dasherize}\">".html_safe
      end
    icon_html image_html, icon, *options
  end

  def icon_html( image_html, icon_name, *options)
    c=[]

    options.delete_if {|o| o.is_a?(Hash) ? false : c<<o}
    options = options[0] || {}
    text_left = options.delete(:text_left)
    text_right = options.delete(:text_right) || options.delete(:text)
    tooltip = options.delete(:tooltip)
    tooltip_options = (tooltip ? { data: { toggle: 'tooltip', title: tooltip } } : {} )
    id = options.delete(:id) || nil
    ("#{text_left}" + content_tag( :i, {id: id, class: "icon icon-#{icon_name} #{c.join(" ")}".dasherize }.merge(tooltip_options) ) do
      image_html
    end + "#{text_right}").html_safe
  end

  def turbolinks_permanent(id, &block)
    anchor = content_tag(:div, "permanent #{id}", "data-turbolinks-permanent": true, id: id)
    return anchor if request.env["HTTP_TURBOLINKS_REFERRER"]
    html = capture(&block)
    anchor << javascript_tag("document.getElementById('#{id}').innerHTML = #{html.inspect};")
  end

end
