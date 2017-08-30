module IconsHelper

  def icon( label, options={})
    size    = options.delete(:size) || 1
    text    = options.delete(:text) || ''
    rotate  = options.delete(:rotate) 
    rotate_class = rotate ? " icon-rotate-#{rotate}" : ''
    on      = options.delete(:on) || :right
    classes = options.delete(:class) || ''
    tooltip = options.delete(:tooltip)
    tooltip_options = (tooltip ? { data: { toggle: 'tooltip', title: tooltip } } : {} )
    spin = options.delete(:spin)
    spin_class = " icon-spin-#{spin}" if spin
    text_tag = content_tag(:span, text, class: 'icon-text') unless text.blank?
    s=''
    s <<  text_tag if text_tag && on == :left
    s << content_tag(:i, '',
                     options.merge( {class: "fontello icon-#{size}x#{rotate_class} icon-#{String(label).dasherize}#{spin_class} #{classes}"}).merge( tooltip_options )
                    )
    s <<  text_tag if text_tag && on == :right
    s.html_safe
  end

  def stacked_icon(*icons)
    content_tag :span, class: 'icon-stack' do
      icons.join('').html_safe
    end
  end

end
