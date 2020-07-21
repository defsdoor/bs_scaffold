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

  def bs_display_value(label, value, options = {}, &block)
    col_width = options[:col_width].nil? ? 6 : options.delete(:col_width)
    col_class = options[:col_class].nil? ? 'md' : options.delete(:col_class).to_s
    class_string = options.delete(:class) || "col-#{col_class}-#{col_width}"
    tag.fieldset class: "form-group col-#{col_class}-#{col_width}" do
      (label ? tag.label(label) : '' ) +
        tag.div(value, {class: 'form-control'})
    end
  end

  def bs_display(model, attribute, options = {}, &block)
    if model.class && model.respond_to?(attribute.to_s)
      value = model.respond_to?("#{attribute.to_s}_display") ? model.send("#{attribute.to_s}_display") : model.send(attribute.to_s)
      as = options[:as].nil? ? model.column_for_attribute(attribute.to_s).type : options.delete(:as)
      col_width = options[:col_width].nil? ? 6 : options.delete(:col_width)
      col_class = options[:col_class].nil? ? 'md' : options.delete(:col_class).to_s
      class_string = options.delete(:class) || "col-#{col_class}-#{col_width}"
      label = tag.label(model.class.human_attribute_name(attribute))

      unless options[:label].nil?
        if options[:label] == false
          label = tag.label('&nbsp;'.html_safe)
        elsif options[:label] == :none
          label="".html_safe
        else
          label = tag.label(options[:label].to_s)
        end
      end

      if model.respond_to?("#{attribute.to_s}_display_as_#{as}")
        inner_content = model.send("#{attribute.to_s}_display_as_#{as}", attribute.to_s, value)
      else
        inner_content = send("common_display_as_#{as}", attribute.to_s, value)
      end

      tag.fieldset label + inner_content, class: "form-group #{class_string}"
    else
      bs_display_value(model, attribute, options, &block)
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

  def common_display_as_decimal(attribute, value)
    tag.div(value, {class: 'form-control', id: attribute})
  end

  def common_display_as_currency(attribute, value)
    tag.div(number_to_currency(value), {class: 'form-control', id: attribute})
  end

  def common_display_as_datetime(attribute, value)
    tag.div(value, {class: 'form-control', id: attribute})
  end

  def common_display_as_date(attribute, value)
    tag.div(value, {class: 'form-control', id: attribute})
  end

  def common_display_as_text(attribute, value)
    common_display_as_string(attribute, value)
  end

  def common_display_as_inet(attribute, value)
    common_display_as_string(attribute, value)
  end

  def common_display_as_association(attribute, value)
    tag.div(value.try(:name) || value.try(:description), id: attribute)
  end

  def common_display_as_switch(attribute, value)
    tag.div class: "controls bootstrap-switch boolean success"  do
      tag.div class: "switch #{value ? "on" :""}" do
        tag.label "switch", class: "hide boolean"
      end
    end
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

  def page_header(title, options={})
    show_icon = options.delete(:icon)
    "#{icon(show_icon, :md) if show_icon }#{h title}".html_safe
  end

  def page_header_content
    content_for(:page_header) || ""
  end

  def table_footer(klass, count)
    tag.div id: "#{klass}TableFooter", class: "table-footer" do
      tag.div class: "record-count" do
        t(:record_count, count: count)
      end
    end
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

  def context_modal_header( object, of=nil )
    title = if object.is_a?(Class)
      t(:import_records, model: object.model_name.human(count: 2))
    else
      t( (object.new_record? ?  :new_record : :edit_record), model: object.model_name.human)
    end
    modal_header title
  end

  def submit_button(object)
    submit_button_tag object.new_record? ? t('create_record', model: object.model_name.human) :  t('update_record', model: object.model_name.human)
  end

  def submit_button_tag(label)
    tag.button label, class: "btn btn-primary", onclick: "Rails.fire($(this).parents('.modal').find('form')[0], 'submit')"
  end

  def cancel_modal(title = t('modal.cancel'))
    tag.button title, class: "btn btn-cancel", data: { dismiss: "modal"} , type: "button"
  end

  def close_modal(title = t('modal.close'), disabled: false)
    tag.button title, class: "close-button btn btn-danger", disabled: disabled, data: { dismiss: "modal"} , type: "button"
  end

  def copy_to_clipboard(target)
    tag.button t('modal.copy'), class: "btn btn-secondary copy-to-clipboard", data: { target: target, copied: t('modal.copied')} , type: "button"
  end

  def edit_button( path )
    link_to icon(:edit, text: t('modal.edit')), path, class: 'btn btn-primary', remote: true, data: { toggle: 'modal', target: '#Modal' }
  end

  def nested_group_options( collection, association, options={} )
    selected = options.delete(:selected)
    s = ""
    collection.each do |c|
      value = "#{c.class.name}_#{c.id}"
      s << "<option value=\"#{value}\" #{selected? value, selected} class=\"optionGroup\">#{c.name}</option>"
      c.send(association).each do |a|
        value = "#{a.class.name}_#{a.id}"
        s << "<option value=\"#{value}\" #{selected? value, selected} class=\"optionChild\">&nbsp;&nbsp;#{a.name}</option>"
      end
    end
    s
  end

  def hide_one_class(s)
    "hide-one" unless params[s].blank?
  end

  def translated_enum_collection_for_select( a, selected )
    options_from_collection_for_select( a, :second, :first, selected )
  end

  private

  def selected?(this, that)
    this == that ?  "selected=\"selected\""  : ""
  end

end
