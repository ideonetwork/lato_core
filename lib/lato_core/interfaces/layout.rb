module LatoCore

  # This module contains a list of functions used to mange the admin layout.
  module Interface::Layout

    # Helpers:

    # This function set the current active page title on the header.
    def core__set_header_active_page_title(title)
      @core__header_active_page_title = title
    end

    # This function set the current active page on the menu.
    def core__set_menu_active_item(item_key)
      @core__menu_active_item = item_key
    end

    # Partials:

    # This function returns a list of partials for the page.
    def core__get_partials
      lato_modules = core__get_modules_list
      # create list of widgets
      partials = []
      lato_modules.each do |lato_module_name|
        module_partials = core__get_partials_for_module(lato_module_name)
        partials += module_partials if module_partials
      end
      # sort items and return them
      partials = partials.sort_by {|partial| partial[:position]}
      partials.reverse
    end

    # This function return the list of partials for a specific module.
    def core__get_partials_for_module(module_name)
      module_configs = core__get_module_configs(module_name)
      return [] unless module_configs
      # load module items
      module_partials = []
      if module_configs[:partials]
        module_configs[:partials].each do |key, value|
          module_partials.push(core__generate_partial(key, value, module_name))
        end
      end
      # return module items
      module_partials
    end

    # This function create a correct partial object for the header.
    def core__generate_partial(key, values, module_name)
      partial = {}
      partial[:key] = key
      partial[:path] = values[:path] ? values[:path] : ''
      partial[:position] = values[:position] ? values[:position] : 999
      partial
    end

    # Widgets:

    # This function return a list of widgets for the header of the layout.
    def core__get_widgets
      lato_modules = core__get_modules_list
      # create list of widgets
      widgets = []
      lato_modules.each do |lato_module_name|
        module_widgets = core__get_widgets_for_module(lato_module_name)
        widgets = widgets + module_widgets if module_widgets
      end
      # sort items and return them
      widgets = widgets.sort_by {|widget| widget[:position]}
      return widgets.reverse
    end

    # This function return the list of widgets for a specific module.
    def core__get_widgets_for_module module_name
      module_configs = core__get_module_configs(module_name)
      return [] unless module_configs
      # load module items
      module_widgets = []
      if module_configs[:widgets]
        module_configs[:widgets].each do |key, value|
          module_widgets.push(core__generate_widget(key, value, module_name))
        end
      end
      # return module items
      return module_widgets
    end

    # This function create a correct widget object for the header.
    def core__generate_widget key, values, module_name
      widget = {}
      widget[:key] = key
      widget[:icon] = values[:icon] ? values[:icon] : 'check-circle'
      widget[:path] = values[:path] ? values[:path] : ''
      widget[:position] = values[:position] ? values[:position] : 999
      widget[:title] = values[:title] ? values[:title] : ''
      return widget
    end

    # Menu:

    # This function returns the list of the items for the menu.
    def core__get_menu
      lato_modules = core__get_modules_list
      # create list of menu items
      menu = []
      lato_modules.each do |lato_module_name|
        module_menu = core__get_menu_for_module(lato_module_name)
        menu = menu + module_menu if module_menu
      end
      # sort items and return them
      menu = menu.sort_by {|menu_item| [menu_item[:position], menu_item[:title]]}
      return menu
    end

    # This function returns the list of the items for the menu for a specific module.
    def core__get_menu_for_module module_name
      module_configs = core__get_module_configs(module_name)
      return [] unless module_configs
      # load module items
      module_menu = []
      if module_configs[:menu]
        module_configs[:menu].each do |key, value|
          module_menu.push(core__generate_menu_item(key, value, module_name))
        end
      end
      # return module items
      return module_menu
    end

    # This function create a correct menu item object for the menu.
    def core__generate_menu_item key, values, module_name
      menu_item = {}
      menu_item[:key] = key
      menu_item[:title] = values[:title] ? core__get_menu_title_translation(values[:title], module_name) : 'Undefined'
      menu_item[:icon] = values[:icon] ? values[:icon] : 'check-circle'
      menu_item[:url] = values[:url] ? values[:url] : ''
      menu_item[:position] = values[:position] ? values[:position] : 999
      menu_item[:permission_min] = values[:permission_min] ? values[:permission_min] : 0
      menu_item[:permission_max] = values[:permission_max] ? values[:permission_max] : 999
      menu_item[:sub_items] = []

      if values[:sub_items]
        values[:sub_items].each do |key, value|
          menu_item[:sub_items].push(core__generate_menu_sub_item(key, value, module_name))
        end
      end

      return menu_item
    end

    # This function create a correct menu sub itam object for the menu.
    def core__generate_menu_sub_item key, values, module_name
      menu_sub_item = {}
      menu_sub_item[:key] = key
      menu_sub_item[:title] = values[:title] ? core__get_menu_title_translation(values[:title], module_name) : 'Undefined'
      menu_sub_item[:url] = values[:url] ? values[:url] : ''
      menu_sub_item[:permission_min] = values[:permission_min] ? values[:permission_min] : 0
      menu_sub_item[:permission_max] = values[:permission_max] ? values[:permission_max] : 999
      return menu_sub_item
    end

    # This function check the title name and, if it need a translaction, it return the value.
    def core__get_menu_title_translation title, module_name
      return title if (!title.start_with?('translate'))

      title_key = core__get_string_inside_strings(title, '[', ']')
      module_languages = core__get_module_languages(module_name)
      return title if !module_languages || !module_languages[:menu] || !module_languages[:menu][title_key]

      return module_languages[:menu][title_key]
    end

    # Assets:

    # This function return an array with the list of assets for lato modules.
    def core__get_assets
      lato_modules = core__get_modules_list
      # create list of menu assets
      assets = []
      lato_modules.each do |lato_module_name|
        module_assets = core__get_assets_for_module(lato_module_name)
        assets = assets + module_assets if module_assets
      end
      # return assets
      return assets
    end

    # This function return the lists of assets for a specific module.
    def core__get_assets_for_module module_name
      module_configs = core__get_module_configs(module_name)
      return [] unless module_configs
      # load module assets
      module_assets = []
      if module_configs[:assets]
        module_configs[:assets].each do |key, value|
          module_assets.push(value)
        end
      end
      # return module assets
      return module_assets
    end

    # Colors:

    # This function return the list of colors set for the tamplate.
    def core__get_colors
      core_configs = core__get_module_configs('lato_core')
      return core_configs[:colors]
    end

  end
end