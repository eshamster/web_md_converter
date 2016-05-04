# coding: utf-8
require_relative '../../web_md_converter'
require 'test/unit'
require 'rack/test'
require 'json'
require_relative '../utils.rb'
require_relative '../../type_manager'

ENV['RACK_ENV'] = 'test'

class WebMdConverter_Templates < Test::Unit::TestCase
  include Rack::Test::Methods
  include PrepareResourceMethods

  setup :create_base_dir
  teardown :delete_base_dir

  def app
    Sinatra::Application
  end

  test "Get templates/lists" do
    get "templates/lists"

    assert last_response.ok?

    res = JSON.parse(last_response.body) 
    res.each { |key, data|
      assert TypeManager::valid?(key)
      assert ["list"].sort == data.keys.sort
    }
  end
end
