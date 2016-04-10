class TemplateManager
  private_class_method :new
  @@base_dir = File.dirname(__FILE__) + '/templates'
  
  class << self
    def search_file_path(type:, name:, specifier:, base_dir: @@base_dir)
      path_name = "#{base_dir}/#{type}/#{name}.#{specifier}"
      if FileTest.exist?(path_name)
        return path_name
      else
        raise StandardError, "The file #{path_name} is not found"
      end
    end

    def get_templates_list(type = '', base_dir = @@base_dir)
      
    end

    def add_new_template(file, type, specifier, base_dir = @@base_dir)
    end
  end
end
