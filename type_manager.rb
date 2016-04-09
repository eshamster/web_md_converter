module TypeManager
  class Base
    attr_reader :content_type, :specifier
    def make_pandoc_opts(params)
    end
    class << self 
      def create(type)
        case type
        when 'html' then
          return Html.new()
        when 'docx' then
          return Word.new()
        else
          raise ArgumentError, "The type '#{type}' is not implemented"
        end
      end
    end
  end

  class Html < Base
    def initialize()
      @content_type = 'text/html'
      @specifier = 'html'
    end

    def make_pandoc_opts(params)
      "not implemented"
    end
  end

  class Word < Base
    def initialize()
      @content_type = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
      @specifier = 'docx'
    end

    def make_pandoc_opts(params)
      "not implemented"
    end
  end
end
