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
  EXIST_NAME = 'test1.css'
  NOT_EXSIST_NAME = 'not_exist.css'

  def app
    Sinatra::Application
  end

  test "Validate parameters used in this test sets" do
    assert TypeManager::valid? type
    assert TemplateManager::exist?(type: type, name: EXIST_NAME)
    assert !TemplateManager::exist?(type: type, name: NOT_EXSIST_NAME)
  end

  # ---------- #
  test "Get templates" do
    get "templates", :type => type, :name => EXIST_NAME
    assert last_response.ok?

    assert_equal TypeManager::create(type).template_content_type,
                 last_response.content_type.sub(/;charset=.*/, '')
  end

  test "Errors of Get templates" do
    # not supported type
    get "templates", :type => 'not_exist', :name => EXIST_NAME
    assert_equal 400, last_response.status

    # not exist file 
    get "templates", :type => type, :name => NOT_EXSIST_NAME
    assert_equal 400, last_response.status
    
    # lack of required param
    get "templates", :type => type
    assert_equal 400, last_response.status

    get "templates", :name => EXIST_NAME
    assert_equal 400, last_response.status
  end

  # ---------- #
  test "Get templates/lists" do
    get "templates/lists"

    assert last_response.ok?
    assert_equal 'application/json', last_response.content_type

    res = JSON.parse(last_response.body) 
    res.each { |key, data|
      assert TypeManager::valid?(key)
      assert ["list"].sort == data.keys.sort
    }
  end
  
  # ---------- #
  test "Post templates" do
    post "templates", :file => unregistered_template_file, :type => type, :name => NOT_EXSIST_NAME
    
    assert last_response.ok?
    assert_equal 'application/json', last_response.content_type
    assert TemplateManager::exist?(type: type, name: NOT_EXSIST_NAME)
  end
  
  test "Errors of Post templates" do
    file = unregistered_template_file

    # register using already registred name
    post "templates", :file => file, :type => type, :name => EXIST_NAME
    assert_equal 400, last_response.status

    # not supported type
     post "templates", :file => file, :type => 'not_exist', :name => NOT_EXSIST_NAME
    assert_equal 400, last_response.status
    
    # lack of required param
    post "templates", :file => file, :type => type
    assert_equal 400, last_response.status
    post "templates", :file => file, :name => NOT_EXSIST_NAME
    assert_equal 400, last_response.status
    post "templates", :type => type, :name => NOT_EXSIST_NAME
    assert_equal 400, last_response.status
  end
  
  # ---------- #
  test "Delete templates" do
    delete "templates", :type => type, :name => EXIST_NAME
    
    assert last_response.ok?
    assert_equal 'application/json', last_response.content_type
    assert !TemplateManager::exist?(type: type, name: EXIST_NAME)
  end

  test "Errors of Delete templates" do
    # delete a not registered template
    delete "templates", :type => type, :name => NOT_EXSIST_NAME
    assert_equal 400, last_response.status

    # not supported type
    delete "templates", :type => 'not_exist', :name => EXIST_NAME
    assert_equal 400, last_response.status

    # lack of required param
    delete "templates", :name => EXIST_NAME
    assert_equal 400, last_response.status
    delete "templates", :type => type
    assert_equal 400, last_response.status    
  end
end
