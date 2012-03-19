module AdminHelper

  def navigation_builder(navigation_array, is_nested=false)
    nav_content = ''.html_safe
    navigation_array.each do |nav|
      content = link_to(nav[0], nav[1])
      nested = nav[2].present? ? navigation_builder(nav[2], true) : nil
      li_class = [('current' if current_page?(nav[1])), ('has_nested' if nested)].compact
      nav_content << content_tag(:li, (content + nested), :id => "nav_#{nav[0].gsub(/[^A-Za-z0-9]/,'_').underscore}", :class => (li_class.empty? ? nil : li_class))
    end
    content_tag(:ul, nav_content, (is_nested ? {} : {:id => 'tabs', :class => 'tabbed_navigation'})).html_safe
  end

  def breadcrumbs_builder(breadcrumbs_array)
    page_title = breadcrumbs_array.pop

    breadcrumb_spacer = '/'.html_safe

    crumbs = ''.html_safe
    breadcrumbs_array.each do |bread|
      crumbs << content_tag(:span, bread) + content_tag(:span, breadcrumb_spacer, :class => 'breadcrumb_sep')
    end
    breadcrumbs = crumbs.empty? ? ''.html_safe : content_tag(:span, crumbs, :class => 'breadcrumb')
    return breadcrumbs + content_tag(:h2, page_title, :id => 'page_title')
  end

  def actions_builder(actions_array)
    actions = ''.html_safe
    actions_array.each do |action|
      actions << content_tag(:span, action, :class => 'action_item')
    end
    return content_tag(:div, actions, :class => 'action_items')
  end

  # def scopes_builder(scopes_array)
  #   '
  #   <div class="scopes">
  #     <span class="scope all selected">
  #       <em>All</em>
  #       <span class="count">(13)</span>
  #     </span>
  #     <span class="scope www">
  #       <a href="/admin/pages?order=id_desc&amp;page=1&amp;scope=www">Www</a>
  #       <span class="count">(0)</span>
  #     </span>
  #     <span class="scope rent">
  #       <a href="/admin/pages?order=id_desc&amp;page=1&amp;scope=rent">Rent</a>
  #       <span class="count">(13)</span>
  #     </span>
  #     <span class="scope localseo_usa">
  #       <a href="/admin/pages?order=id_desc&amp;page=1&amp;scope=localseo_usa">Localseo Usa</a>
  #       <span class="count">(0)</span>
  #     </span>
  #     <span class="scope localseo_canada">
  #       <a href="/admin/pages?order=id_desc&amp;page=1&amp;scope=localseo_canada">Localseo Canada</a>
  #       <span class="count">(0)</span>
  #     </span>
  #   </div>
  #   '
  # end

  def empty_value_tag
    content_tag(:span, 'Empty', :class => 'empty')
  end

  def boolean_value(value)
    content_tag(:span, value ? 'True' : 'False', :class => 'boolean')
  end

  def required_mark
    content_tag(:abbr, '*', :title => 'required')
  end

  def attribute_name(attribute)
    return attribute unless attribute.is_a?(Array)
    return attribute[0]
  end

  def attribute_value(object, attr_name)
    if attr_name.to_s.include?('.')
      match = attr_name.to_s.match(/^(.*?)\.(.*)$/)
      attribute_value(object.send(match[1]), match[2])
    else
      object.send(attr_name)
    end
  end

  def displaying_attribute_value(object, attribute)
    attribute = [attribute] unless attribute.is_a?(Array)
    options = attribute[1] || {}

    value = if options.has_key?(:value)
      if options[:value].is_a?(Proc)
        options[:value].call(object)
      else
        options[:value]
      end
    else
      attr_name = attribute_name(attribute)
      column_hash_attribute = object.class.columns_hash[attr_name.to_s]

      if column_hash_attribute && column_hash_attribute.type == :boolean
        boolean_value(attribute_value(object, :"#{attr_name}?"))
      else
        attribute_value(object, attr_name)
      end
    end
    if options[:collection].present?
      value_in_collection = options[:collection].rassoc(value)
      value = value_in_collection[0] unless value_in_collection.nil?
    end

    value
  end

  def attribute_header_content(attribute)
    attr_name = attribute_name(attribute)

    content = attr_name.is_a?(Symbol) ? attr_name.to_s.titleize : attr_name
    if attribute.is_a?(Array) && attribute[1].present?
      content = attribute[1][:label] if attribute[1][:label].present?
    end
    content
  end

  def entry_names(collection, options={})
    if options[:entry_name]
      entry_name = options[:entry_name]
      entries_name = options[:entries_name]
    elsif collection.empty?
      entry_name = 'entry'
      entries_name = 'entries'
    else
      entry_name = (collection.is_a?(ActiveRecord::Relation) ? collection.build : collection.first).class.model_name.demodulize
      entries_name = nil
    end
    entries_name = entry_name.pluralize unless entries_name

    {:entry_name => entry_name, :entries_name => entries_name}
  end

end
