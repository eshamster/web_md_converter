require 'fileutils'

class TemplateManager
  private_class_method :new
  @@base_dir = File.dirname(__FILE__) + '/templates'
  
  class << self
    def search_file_path(type:, name:, base_dir: @@base_dir)
      path_name = create_path(base_dir, type, name)
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

    def add(src_path:, type:, dst_name:, base_dir: @@base_dir)
      templates = get_templates_of_type(base_dir, type)
      if templates.include?(dst_name)
        raise StandardError, "The template '#{dst_name}' is already registered"
      end
      dst_path = create_path(base_dir, type, dst_name)
      unless FileUtils.copy_file(src_path, dst_path, true)
        raise StandardError, "The copy from #{src_path} to #{dst_path} is failed"
      end
      return true
    end

    def get_template(type, specifier, base_dir = @@base_dir)
      raise NotImplementedError.new("")
    end

    def update_template(file, type, specifier, base_dir = @@base_dir)
      raise NotImplementedError.new("")
    end

    def delete(type:, name:, base_dir: @@base_dir)
      templates = get_templates_of_type(base_dir, type)
      unless templates.include?(name)
        raise StandardError, "The template '#{name}' is not registered"
      end
      path = create_path(base_dir, type, name)
      unless FileUtils.rm(path)
        raise StandardError, "Deletng #{path} is failed"
      end
      return true
    end

    private

    def create_path(base_dir, type, name)
      return "#{base_dir}/#{type}/#{name}"
    end

    def get_templates_of_type(base_dir, type)
      unless TypeManager::is_valid?(type)
        raise StandardError, "The type '#{type}' is invalide"
      end
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
