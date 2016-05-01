# coding: utf-8
require_relative '../../web_md_converter'
require 'test/unit'
require 'rack/test'
require_relative '../utils.rb'

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
end
