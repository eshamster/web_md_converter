require 'test/unit'
require_relative '../template_manager.rb'
require_relative 'utils.rb'

class TestTemplateManager < Test::Unit::TestCase
  include PrepareResourceMethods

  setup :create_base_dir
  teardown :delete_base_dir

  # ---------- #
  test 'Test search_file_path' do
    assert_equal(TemplateManager::search_file_path(type: 'html', name: 'test1.css'),
                 "#{@@template_dir}/html/test1.css")
    assert_equal(TemplateManager::search_file_path(type: 'word', name: 'test2.dotx'),
                 "#{@@template_dir}/word/test2.dotx")
  end

  test 'Test error of search_file_path' do
    assert_raise(StandardError) do
      TemplateManager::search_file_path(type: 'not_exist', name: 'test1.css')
    end
    assert_raise(StandardError) do
      TemplateManager::search_file_path(type: 'html', name: 'not_exist')
    end
  end

  # ---------- #
  test 'Test get_templates_list' do
    assert_same_content(TemplateManager::get_templates_list(type: 'html'),
                        { 'html' => ['test1.css', 'test2.css', 'test3.css'] })
    assert_same_content(TemplateManager::get_templates_list(type: 'word'),
                        { 'word' => ['test1.dotx', 'test2.dotx'] })
    assert_same_content(TemplateManager::get_templates_list,
                        { 'html' => ['test1.css', 'test2.css', 'test3.css'], 
                          'word' => ['test1.dotx', 'test2.dotx'] })
  end

  test 'Test error of get_templates_list' do
    assert_raise(StandardError) do
      TemplateManager::get_templates_list(type: 'not_exist')
    end
  end

  # ---------- #
  test 'Test add' do
    type = 'html'
    new_name = 'test_new.css'
    TemplateManager::add(src_path: @@css_path_for_add,
                         type: type, dst_name: new_name)
    assert template_is_exist?(type, new_name)
  end

  test 'Test error of add' do
    assert_raise(StandardError) do
      # Try to override a existing file (not allowed)
      TemplateManager::add(src_path: @@css_path_for_add,
                           type: 'html', dst_name: 'test1.css')
    end
    assert_raise(StandardError) do
      TemplateManager::add(src_path: @@css_path_for_add,
                           type: 'not_exist', dst_name: 'test_new.css')
    end
  end

  # ---------- #
  test 'Test get' do
    path = TemplateManager::get(type: 'html', name: 'test1.css')
    assert File.exist?(path)
  end

  test 'Test error of get' do
    assert_raise(StandardError) do
      TemplateManager::get(type: 'not_exist', name: 'test1.css')
    end
    assert_raise(StandardError) do
      TemplateManager::get(type: 'html', name: 'not_exist')
    end
  end

  # ---------- #
  test 'Test update' do
    # TODO: compare the content of the file between before and after
    type = 'html'
    name = 'test1.css'
    assert template_is_exist?(type, name)
    TemplateManager::update(src_path: @@css_path_for_add,
                            type: type, dst_name: name)
    assert template_is_exist?(type, name)
  end

  test 'Test error of update' do
    assert_raise(StandardError) do
      # Try to override a existing file (not allowed)
      TemplateManager::update(src_path: @@css_path_for_add,
                              type: 'html', dst_name: 'not_exist.css')
    end
    assert_raise(StandardError) do
      TemplateManager::update(src_path: @@css_path_for_add,
                              type: 'not_exist', dst_name: 'test_new.css')
    end
  end

  # ---------- #
  test 'Test delete' do
    type = 'html'
    target_name = 'test1.css'
    assert template_is_exist?(type, target_name)
    TemplateManager::delete(type: type, name: target_name)
    assert ! template_is_exist?(type, target_name)
  end

  test 'Test error of delete_new_template' do
    assert_raise(StandardError) do
      TemplateManager::delete(type: 'html', name: 'not_exist.css')
    end
    assert_raise(StandardError) do
      TemplateManager::delete(type: 'not_exist', name: 'test1.css')
    end
  end
  
  # ----- private ----- #
  private

  def template_is_exist?(type, name)
    return TemplateManager::get_templates_list[type].include?(name)
  end

  @@css_path_for_add = "#{@@base_dir}/css_for_add.css"
end
