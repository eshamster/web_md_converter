# coding: utf-8
require_relative '../../web_md_converter'
require 'test/unit'
require 'rack/test'
require 'json'
require_relative '../utils'
require_relative '../../type_manager'

ENV['RACK_ENV'] = 'test'

class WebMdConverter < Test::Unit::TestCase
  include Rack::Test::Methods

  test "Test GET types" do
    get '/types'
    assert last_response.ok?
    assert_equal "application/json",
                 last_response.content_type

    json = nil
    assert_nothing_raised do
      json = JSON.parse(last_response.body)
    end
    
    TypeManager::all_supported_types.each { |type|
      assert json[type]
      assert_same_content ["content_type",
                           "template_content_type",
                           "specifier"],
                          json[type].keys
    }
  end
end
