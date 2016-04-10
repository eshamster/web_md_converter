class TemplateManager
  private_class_method :new
  @@base_dir = File.dirname(__FILE__) + '/templates'
  
  class << self
    def search_file_path(type, name, specifier = type, base_dir = @@base_dir)
      
    end

    def get_templates_list(type = '', base_dir = @@base_dir)
      
    end

    def add_new_template(file, type, base_dir = @@base_dir)
    end
  end
end
