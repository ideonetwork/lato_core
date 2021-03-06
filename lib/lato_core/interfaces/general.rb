module LatoCore

  # This module contains a list of general functions used as helpers on the system.
  module Interface::General

    # This function takes a path to a yaml file and return the hash with yaml data
    # or nil if file not exist.
    def core__read_yaml(file_path)
      # return nil if file not exist
      return unless File.exist?(file_path)
      config_file = File.read(file_path)
      # return yaml data
      return YAML.safe_load(config_file).with_indifferent_access
    rescue
      nil
    end

    # This function return the substring inside two strings.
    def core__get_string_inside_strings(string, marker1, marker2)
      string[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1]
    end

    # This function paginate an array and return the requested page.
    def core__paginate_array(array, per_page, page)
      start = (page - 1) * per_page
      array[start, per_page]
    end

    # This function add a new GET param to an url string.
    def core__add_param_to_url(url, param_name, param_value)
      uri = URI(url)
      params = URI.decode_www_form(uri.query || "") << [param_name, param_value]
      uri.query = URI.encode_www_form(params)
      uri.to_s
    end

  end

end
