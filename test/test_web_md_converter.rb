# coding: utf-8
require_relative '../web_md_converter'
require 'test/unit'
require 'rack/test'
require_relative 'utils.rb'

ENV['RACK_ENV'] = 'test'

class WebMdConverter < Test::Unit::TestCase
  include Rack::Test::Methods
  include PrepareResourceMethods

  def app
    Sinatra::Application
  end

  def test_root
    get '/'
    assert last_response.ok?
    assert_equal "text/html;charset=utf-8",
                 last_response.header["Content-Type"]
                 
  end

  sub_test_case 'Test converter' do
    setup :create_base_dir
    teardown :delete_base_dir

    def sample_md
      file_name = @@base_dir + '/sample.md'
      return Rack::Test::UploadedFile.new(file_name)
    end

    data('Html' => ['html', 'text/html;charset=utf-8'],
         'Word' => ['word', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'])
    def test_without_template(data)
      type, content_type = data
      post "convert", "file" => sample_md(), "output_type" => type

      assert last_response.ok?
      assert_equal content_type, last_response.header["Content-Type"]
    end
  end
end
