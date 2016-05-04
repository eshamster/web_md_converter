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

  test "Validate parameters used in this test sets" do
    assert TypeManager::valid? type
    assert TemplateManager::exist?(type: type, name: template_name)
  end

  # ---------- #
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

  # ---------- #
  test "Get templates/lists" do
    get "templates/lists"

    assert last_response.ok?

    res = JSON.parse(last_response.body) 
    res.each { |key, data|
      assert TypeManager::valid?(key)
      assert ["list"].sort == data.keys.sort
    }
  end
  
  # ---------- #
  test "Post templates" do
    name = 'new.css'
    assert !TemplateManager::exist?(type: type, name: name)
    
    post "templates", :file => unregistered_template_file, :type => type, :name => name 
    
    assert last_response.ok?
    assert TemplateManager::exist?(type: type, name: name)
  end
  
  test "Errors of Post templates" do
    file = unregistered_template_file

    # register using already registred name
    registered_name = 'test1.css'
    assert TemplateManager::exist?(type: type, name: registered_name)
    post "templates", :file => file, :type => type, :name => registered_name
    assert_equal 400, last_response.status

    # not supported type
    name = 'new.css'
    post "templates", :file => file, :type => 'not_exist', :name => name
    assert_equal 400, last_response.status
    
    # lack of required param
    post "templates", :file => file, :type => type
    assert_equal 400, last_response.status
    post "templates", :file => file, :name => 'new.css'
    assert_equal 400, last_response.status
    post "templates", :type => type, :name => 'new.css'
    assert_equal 400, last_response.status
  end
  
  # ---------- #
  test "Delete templates" do
    name = 'test1.css'
    assert TemplateManager::exist?(type: type, name: name)
    
    delete "templates", :type => type, :name => name
    
    assert last_response.ok?
    assert !TemplateManager::exist?(type: type, name: name)
  end

  test "Errors of Delete templates" do
    name = 'test1.css'
    
    # delete a not registered template
    delete "templates", :type => type, :name => 'not_exist'
    assert_equal 400, last_response.status

    # not supported type
    delete "templates", :type => 'not_exist', :name => name
    assert_equal 400, last_response.status

    # lack of required param
    delete "templates", :name => name
    assert_equal 400, last_response.status
    delete "templates", :type => type
    assert_equal 400, last_response.status    
  end
end
