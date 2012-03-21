module ActiveAdminHelper

  def utility_nav
    if defined?(::Devise)
      devise_scope = Devise.default_scope
      if send(:"#{Devise.mappings[devise_scope].singular}_signed_in?")
        content_tag(:p, :id => 'utility_nav') do
          content_tag(:span, send(:"current_#{Devise.mappings[devise_scope].singular}").email, :class => 'current_user') +
          link_to('Logout', send(:"destroy_#{Devise.mappings[devise_scope].singular}_session_path"), :method => Devise.mappings[devise_scope].sign_out_via)
        end
      end
    end
  end

  def sidebar_associations_builder(associations_array)
    content = ''.html_safe
    associations_array.each do |association|
      content << content_tag(:div, association, :class => 'association')
    end
    return content_tag(:div, content_tag(:h3, 'Associations') + content_tag(:div, content, :class => 'panel_contents'), :id => "associations_sidebar_section", :class => 'sidebar_section panel')
  end

  def panel_attributes(object, attributes=[], options={})
    options.reverse_merge!(:title => object.class.to_s.demodulize)

    contents = ''.html_safe
    attributes.each do |attribute|
      attribute_content = displaying_attribute_value(object, attribute)

      contents << content_tag(:tr) do
        content_tag(:th, attribute_header_content(attribute)) +
        content_tag(:td, attribute_content.present? ? attribute_content : empty_value_tag)
      end
    end

    panel_content("#{options[:title]} Details") do
      content_tag(:div, :id => "attributes_table_#{object.class.to_s.underscore}_#{object.id}", :class => "attributes_table #{object.class.to_s.underscore}") do
        content_tag(:table, :border => '0', :cellspacing => '0', :cellpadding => '0') do
          content_tag(:tbody, contents)
        end
      end
    end
  end

  def index_table(collection, attributes=[], options={})
    options.reverse_merge!(entry_names(collection, options)) if options[:entry_name].nil? || options[:entries_name]

    if collection.is_a?(ActiveRecord::Relation) && (collection.methods & [:page, :per]).size == 2
      paginated_collection(collection, attributes, options)
    else
      table_content(collection, attributes, options)
    end
  end

  def panel_table(title, collection, attributes=[], options={})
    panel_content(title) do
      table_content(collection, attributes, options)
    end
  end

  def panel_content(title, &block)
    content_tag(:div, :class => 'panel') do
      content_tag(:h3, title.html_safe) +
      content_tag(:div, yield, :class => 'panel_contents')
    end
  end

  def paginated_collection(collection, attributes=[], options={})
    content_tag(:div, :class => 'paginated_collection') do
      content_tag(:div, :class => 'paginated_collection_contents') do
        content_tag(:div, table_content(collection, attributes, options), :class => 'index_as_table')
      end +
      content_tag(:div, :id => 'index_footer') do
        paginate(collection) +
        pagination_information(collection, options)
      end
    end
  end

  def pagination_information(collection, options)
    content = if collection.num_pages < 2
      case collection.size
      when 0 then "No #{options[:entries_name]} found"
      when 1 then "Displaying #{content_tag(:b, 1)} #{options[:entry_name]}"
      else "Displaying #{content_tag(:b, "all #{collection.total_count}")} #{options[:entries_name]}"
      end
    else
      offset = collection.current_page * collection.size
      total  = collection.total_count
      "Displaying #{options[:entries_name]} #{content_tag(:b, "#{offset - collection.size + 1}&nbsp;-&nbsp;#{offset > total ? total : offset}".html_safe)} of #{content_tag(:b, total)} in total"
    end

    content_tag(:div, content.html_safe, :class => 'pagination_information')
  end

  def table_content(collection, attributes=[], options={})
    options.reverse_merge!(:actions => [:select], :class => 'index_table')
    options.reverse_merge!(entry_names(collection, options)) if options[:entry_name].nil? || options[:entries_name]
    options[:id] = options[:entries_name].underscore if options[:id].nil?

    sortable = options.delete(:sortable) || false

    sort_column = options.delete(:sort_column).to_s rescue nil
    sort_direction = (options.delete(:sort_direction) || 'asc').downcase

    head_content = ''.html_safe
    head_content << content_tag(:th, ''.html_safe) if sortable && sortable.is_a?(TrueClass)
    attributes.each do |attribute|
      attr_name = attribute_name(attribute)

      header_content = attribute_header_content(attribute)
      header_class = ['attr', "attr-#{attr_name}"]

      if attribute.is_a?(Array) && attribute[1].present?
        sortable_attribute = attribute[1][:sortable] || false
        if sortable == false && sortable_attribute
          currently_sorted = sort_column == attr_name.to_s

          header_content = link_to(header_content, url_for(:order => "#{attr_name}_#{currently_sorted && sort_direction == 'asc' ? 'desc' : 'asc'}"))
          header_class << 'sortable'
          header_class << "sorted-#{sort_direction}" if currently_sorted
        end
      end

      head_content << content_tag(:th, header_content, :class => header_class)
    end
    head_content << content_tag(:th, ''.html_safe) unless options[:actions].nil?

    body_content = ''.html_safe
    collection.each do |item|
      options.reverse_merge!(:item_name => item.class.to_s.demodulize.humanize)

      row_content = ''.html_safe
      row_content << content_tag(:td, content_tag(:span, ''.html_safe, :class => 'handle')) if sortable && sortable.is_a?(TrueClass)

      attributes.each do |attribute|
        attr_name = attribute_name(attribute)
        cell_class = ['attr', "attr-#{attr_name}"]

        attribute_content = displaying_attribute_value(item, attribute)

        if sortable && sortable == attr_name
          attribute_content = content_tag(:span, attribute_content, :class => 'handle')
        end

        row_content << content_tag(:td, attribute_content, :class => cell_class)
      end

      unless options[:actions].nil?
        actions = ''.html_safe
        options[:actions].each do |action|
          link_class = ['member_link']

          actions << case action
          when :edit then link_to('Edit', [:edit, :admin, item], :class => link_class.push('edit_link'))
          when :delete then link_to('Delete', [:admin, item], :class => link_class.push('delete_link'), :method => :delete, :confirm => "Are you sure you want to destroy this #{options[:item_name].downcase}?")
          when :select then link_to('Select', [:admin, item], :class => link_class.push('view_link'))
          end
        end

        row_content << content_tag(:td, actions)
      end

      body_content << content_tag(:tr, row_content, :id => "#{item.class.to_s.demodulize.underscore}_#{item.id}", :class => cycle('odd','even', :name => "#{item.class.to_s.pluralize.underscore}_row_class"))
    end

    content_tag(:table, :border => '0', :cellspacing => '0', :cellpadding => '0', :id => options[:id], :class => options[:class], 'data-sortable-table' => (sortable if sortable)) do
      content_tag(:thead) do
        content_tag(:tr, head_content)
      end +
      content_tag(:tbody, body_content)
    end
  end

  def form_content(form_object, fields=[], options={})
    form_field_items(form_object, fields, options) + form_buttons(form_object)
  end

  def form_buttons(form_object)
    content_tag(:fieldset, :class => 'buttons') do
      content_tag(:ol) do
        content_tag(:li, form_object.nil? ? submit_tag : form_object.submit, :class => 'commit') +
        content_tag(:li, link_to('Cancel', :back), :class => 'cancel')
      end
    end
  end

  def form_field_items(form_object, fields=[], options={})
    options.reverse_merge!(:legend => (form_object.object.class.to_s.demodulize unless form_object.nil?))

    content = ''.html_safe
    fields.compact.each do |field|
      content << field_item(form_object, field[0], field[1])
    end

    content_tag(:fieldset, :class => 'inputs', :name => options[:legend]) do
      content_tag(:legend, content_tag(:span, options[:legend])) +
      content_tag(:ol, content)
    end
  end

  def field_item(form, column, options={})
    options = {} if options.nil?
    options.reverse_merge!(:type => 'string', :required => false, :label => column.to_s.titleize, :collection => [])
    type = options.delete(:type)
    required = options.delete(:required)
    collection = options.delete(:collection)

    label_value = options.delete(:label).html_safe
    label_value << required_mark if required

    li_class = [type, (required ? 'required' : 'optional')]

    if form.nil?
      content = case type
      when 'boolean'
        hidden_field_tag(column, '0', :id => nil) +
        label_tag(column, check_box_tag(column, '1') + label_value)
      # when 'date' then label_tag(column, label_value) + date_select(column, options)
      when 'select'
        select_options = options.extract!(:multiple, :disabled, :include_blank, :prompt)
        label_tag(column, label_value) + select_tag(column, collection, select_options, options)
      when 'string'
        options.reverse_merge!(:size => nil)
        label_tag(column, label_value) + text_field_tag(column, options)
      when 'text'
        label_tag(column, label_value) + text_area_tag(column, nil, options)
      end
    else
      content = case type
      when 'boolean'
        form.label(column, form.check_box(column, options) + label_value)
      when 'date' then form.label(column, label_value) + form.date_select(column, options)
      when 'grouped_select'
        group_method = options.delete(:group_method)
        group_label_method = options.delete(:group_label_method)
        option_key_method = options.delete(:option_key_method)
        option_value_method = options.delete(:option_value_method)
        select_options = options.extract!(:multiple, :disabled, :include_blank, :prompt)
        form.label(column, label_value) + form.grouped_collection_select(column, collection, group_method, group_label_method, option_key_method, option_value_method, select_options, options)
      when 'select'
        select_options = options.extract!(:multiple, :disabled, :include_blank, :prompt)
        form.label(column, label_value) + form.select(column, collection, select_options, options)
      when 'string'
        options.reverse_merge!(:size => nil, :maxlength => (form.object.class.columns_hash[column.to_s].limit if form.object.class.columns_hash[column.to_s]))
        form.label(column, label_value) + form.text_field(column, options)
      when 'text'
        form.label(column, label_value) + form.text_area(column, options)
      end

      if form.object.errors.include?(column)
        content << content_tag(:p, form.object.errors[column].join(', '), :class => 'inline-errors')
        li_class << 'error'
      end
    end

    content_tag(:li, content, :id => ("#{form.object.class.to_s.underscore.gsub(/\//, '_')}_#{column.to_s.underscore}_input" unless form.nil?), :class => li_class)
  end

end
