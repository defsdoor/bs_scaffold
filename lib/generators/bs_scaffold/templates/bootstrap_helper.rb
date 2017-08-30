module BootstrapHelper
  def bs_row(content_or_options_with_block = nil, options = nil, escape = true, &block)
    if block_given?
      options, escape = [content_or_options_with_block, options]
      content_tag_string(:div, capture(&block), add_to_hash(options, :class, 'row'), escape)
    else 
      content_tag_string(:div, content_or_options_with_block, add_to_hash(options, :class, 'row'), escape)
    end
  end

  def bs_col(content_or_options_with_block = nil, options = nil, escape = true, &block)
    options,escape = block_given? ? [content_or_options_with_block, options] : [options, escape]
    if block_given?
      content_tag_string(:div, capture(&block), options, escape)
    else
      content_tag_string(:div, content_or_options_with_block, options, escape)
    end
  end 

  def bs_field(label, content_or_options_with_block = nil, options = {}, escape = true, &block )
    if block_given?
      options, escape = [content_or_options_with_block, options]
      bs_fieldset( label, capture(&block), options || {} )
    else
      content_or_options_with_block = '&nbsp;'.html_safe if content_or_options_with_block.nil? || (content_or_options_with_block.methods.include?(:empty?) && content_or_options_with_block.empty?)
      bs_fieldset( label, content_or_options_with_block, options)
    end
  end 

  def bs_fieldset( label, content, options={} )
    form_control_class= options.delete(:form_control) || 'form-control'
    form_group_class = options.delete(:form_group) || 'form-group'
    
    s = label ? content_tag_string(:label, label, nil) : ''.html_safe 
    content_tag_string :fieldset,
      s + 
        content_tag_string( :div, content, add_to_hash(options, :class, form_control_class) ),
      class: form_group_class
  end

  def yesno(value)
    value ? "Yes" : "No"
  end
    
  def add_to_hash(hash, key, value )
    if hash
      hash[key] = hash.has_key?( key ) ? hash[key] + ' ' + value : value
    else 
      hash = { key => value}
    end
    hash
  end

  def tick_box(value)
    value ? icon(:check) : icon(:check_empty)
  end

  def modal_header(title)
    content_tag :div,
      content_tag( :h4, title, class: 'modal-title'),
      class: 'modal-header'
  end

  def context_modal_header( form, title )
    modal_header "#{form.object.new_record? ? 'New' : 'Edit'} #{title}"
  end

  def cancel_modal
    content_tag :button, 'Cancel', class: "btn btn-danger", data: { dismiss: "modal"} , type: "button"
  end

  def edit_button( path )
    link_to icon(:edit, text: 'Edit'), path, class: 'btn btn-primary', remote: true, data: { toggle: 'modal', target: '#Modal' }
  end

end
