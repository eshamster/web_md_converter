require_relative './template_manager'

module TypeManager
  # ----- Module Methods ----- #
  class << self
    def all_supported_types()
      return ['html', 'word']
    end

    def valid?(type)
      return all_supported_types.include?(type)
    end
    
    def create(type)
      case type
      when 'html' then
        return Html.new()
      when 'word' then
        return Word.new()
      else
        unless valid?(type)
          raise ArgumentError, "The type '#{type}' is not supported"
        else
          raise StandardError, "The type '#{type}' is not implemented"
        end
      end
    end
  end

  # ----- Classes ----- #
  class Base
    attr_reader :content_type, :specifier, :template_content_type
    def make_pandoc_opts(params)
    end
  end

  class Html < Base
    def initialize()
      @content_type = 'text/html'
      @template_content_type = 'text/css'
      @specifier = 'html'
    end
    
    def make_pandoc_opts(params)
      result = "-s --self-contained -t html5"
      if params[:template] && ! params[:template].empty?
        path = TemplateManager::search_file_path(type: 'html', name: params[:template])
        result += " -c #{path}"
      end
      return result
    end
  end

  class Word < Base
    def initialize()
      @content_type = 
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
      @template_content_type = 
        'application/vnd.openxmlformats-officedocument.wordprocessingml.template'
      @specifier = 'docx'
    end

    def make_pandoc_opts(params)
    end
  end
end
