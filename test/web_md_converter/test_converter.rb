# coding: utf-8
require_relative '../../web_md_converter'
require 'test/unit'
require 'rack/test'
require_relative '../utils.rb'

ENV['RACK_ENV'] = 'test'

class WebMdConverter < Test::Unit::TestCase
  include Rack::Test::Methods
  include PrepareResourceMethods

  setup :create_base_dir
  teardown :delete_base_dir

  def app
    Sinatra::Application
  end
  
  data('Html' => ['html', 'text/html;charset=utf-8'],
       'Word' => ['word', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'])
  def test_without_template(data)
    type, content_type = data
    post "convert", "file" => sample_md(), "output_type" => type

    assert last_response.ok?
    assert_equal content_type, last_response.header["Content-Type"]
  end

  def test_error_invalid_file
    type = 'html'
    post "convert", "output_type" => type
    assert_equal 400, last_response.status
  end

  def test_error_invalid_output_type
    post "convert", "file" => sample_md()
    assert_equal 400, last_response.status
    post "convert", "file" => sample_md(), "output_type" => 'not_exist_type'
    assert_equal 400, last_response.status
  end

  private
  
  def sample_md
    unregistered_template_file
  end 
end
