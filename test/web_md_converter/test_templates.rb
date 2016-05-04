# coding: utf-8
require_relative '../../web_md_converter'
require 'test/unit'
require 'rack/test'
require 'json'
require_relative '../utils.rb'
require_relative '../../template_manager'
require_relative '../../type_manager'

ENV['RACK_ENV'] = 'test'

class WebMdConverter_Templates < Test::Unit::TestCase
  include Rack::Test::Methods
  include PrepareResourceMethods

  setup :create_base_dir
  teardown :delete_base_dir

  type = 'html'
  template_name = 'test1.css'

  def app
    Sinatra::Application
  end

  test "Validate parameters used in test sets" do
    assert TypeManager::valid? type
    assert TemplateManager::exist?(type: type, name: template_name)
  end

  test "Get templates" do
    get "templates", :type => type, :name => template_name
    assert last_response.ok?

    assert_equal TypeManager::create(type).template_content_type,
                 last_response.content_type.sub(/;charset=.*/, '')
  end

  test "Errors of Get templates" do
    # not supported type
    get "templates", :type => 'not_exist', :name => template_name
    assert_equal 400, last_response.status

    # not exist file 
    get "templates", :type => type, :name => 'not_exist' 
    assert_equal 400, last_response.status
    
    # lack of required param
    get "templates", :type => type
    assert_equal 400, last_response.status

    get "templates", :name => template_name
    assert_equal 400, last_response.status
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
