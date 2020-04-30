module BootstrapHelper

  def back_to_field
    hidden_field_tag :back_to, @back_to if @back_to
  end

  def bs_row(content_or_options_with_block = nil, options = nil, &block)
    if block_given?
      options = content_or_options_with_block
      tag.div capture(&block), add_to_hash(options, :class, 'row')
    else 
      tag.div content_or_options_with_block, add_to_hash(options, :class, 'row')
    end
  end

  def bs_col(content_or_options_with_block = nil, options = nil, &block)
    options = block_given? ? content_or_options_with_block : options
    if block_given?
      tag.div capture(&block), options
    else
      tag.div content_or_options_with_block, options
    end
  end 

  def bs_display(model, attribute, options = {}, &block)
    if model.class && model.respond_to?(attribute.to_s)
      value = model.respond_to?("#{attribute.to_s}_display") ? model.send("#{attribute.to_s}_display") : model.send(attribute.to_s)
      as = options[:as].nil? ? model.column_for_attribute(attribute.to_s).type : options.delete(:as)
      col_width = options[:col_width].nil? ? 6 : options.delete(:col_width)
      label = tag.label(model.class.human_attribute_name(attribute))

      unless options[:label].nil?
        if options[:label] == false
          label = tag.label('&nbsp;'.html_safe)
        else
          label = tag.label(options[:label].to_s)
        end
      end

      if model.respond_to?("#{attribute.to_s}_display_as_#{as}")
        inner_content = model.send("#{attribute.to_s}_display_as_#{as}", attribute.to_s, value)
      else
        inner_content = send("common_display_as_#{as}", attribute.to_s, value)
      end

      tag.fieldset label + inner_content, class: "form-group col-sm-#{col_width}"
    end
  end

  def common_display_as_string(attribute, value)
    tag.div(value, {class: 'form-control', id: attribute})
  end

  def common_display_as_boolean(attribute, value)
    bg_color = (value == true) ? 'bg-success' : 'bg-danger'
    tag.div(value, {class: "boolean-field form-control #{bg_color}", id: attribute})
  end

  def common_display_as_integer(attribute, value)
    tag.div(value, {class: 'form-control', id: attribute})
  end

  def common_display_as_datetime(attribute, value)
    tag.div(value, {class: 'form-control', id: attribute})
  end

  def bs_field(label, content_or_options_with_block = nil, options = {}, &block )
    if block_given?
      options = content_or_options_with_block
      bs_fieldset( label, capture(&block), options || {} )
    else
      content_or_options_with_block = '&nbsp;'.html_safe if content_or_options_with_block.nil? || (content_or_options_with_block.methods.include?(:empty?) && content_or_options_with_block.empty?)
      bs_fieldset( label, content_or_options_with_block, options)
    end
  end 

  def bs_fieldset( label, content, options={} )
    form_control_class= options.delete(:form_control) || 'form-control'
    form_group_class = options.delete(:form_group) || 'form-group'
    
    s = label ? tag.label( label ) : ''.html_safe 
    options = add_to_hash(options, :class, form_control_class)
    tag.fieldset s + tag.div( content, options ),
      class: form_group_class
  end

  def yesno(value, opt= ["Yes", "No"])
    value ? opt[0] : opt[1]
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

  def modal_header(title=nil, &block)
    if block_given?
    tag.div tag.h4( capture(&block), class: 'modal-title'),
      class: 'modal-header'
    else
      tag.div tag.h4( title, class: 'modal-title'),
        class: 'modal-header'
    end
  end

  def context_modal_header( form, title )
    modal_header "#{form.object.new_record? ? 'New' : 'Edit'} #{title}"
  end

  def cancel_modal(title = 'Cancel')
    tag.button title, class: "btn btn-danger", data: { dismiss: "modal"} , type: "button"
  end

  def edit_button( path )
    link_to icon(:edit, text: 'Edit'), path, class: 'btn btn-primary', remote: true, data: { toggle: 'modal', target: '#Modal' }
  end

end
