class TemplateManager
  private_class_method :new
  @@base_dir = File.dirname(__FILE__) + '/templates'
  
  class << self
    def search_file_path(type:, name:, base_dir: @@base_dir)
      path_name = "#{base_dir}/#{type}/#{name}"
      if FileTest.exist?(path_name)
        return path_name
      else
        raise StandardError, "The file #{path_name} is not found"
      end
    end

    def get_templates_list(type: nil, base_dir: @@base_dir)
      dir_list = type ? [ type ] : get_real_entries(base_dir)
      result = {}
      dir_list.each { |dir|
        result[dir] = get_templates_of_type(base_dir, dir)
      }
      return result
    end

    def add_new_template(file, type, specifier, base_dir = @@base_dir)
      raise NotImplementedError.new("")
    end

    def get_template(type, specifier, base_dir = @@base_dir)
      raise NotImplementedError.new("")
    end

    def update_template(file, type, specifier, base_dir = @@base_dir)
      raise NotImplementedError.new("")
    end

    def delete_template(type, specifier, base_dir = @@base_dir)
      raise NotImplementedError.new("")
    end

    private

    def get_templates_of_type(base_dir, type)
      return get_real_entries("#{base_dir}/#{type}")
    end
    
    def get_real_entries(dir_path) 
      if FileTest.exist?(dir_path)
        return Dir.entries(dir_path).reject{|e| e.start_with?(".")}
      else
        raise StandardError, "The directory #{dir_path} is not found"
      end
    end
  end
end
