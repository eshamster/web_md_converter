require 'test/unit'
require_relative '../template_manager.rb'
require_relative 'utils.rb'

class TestTemplateManager < Test::Unit::TestCase
  include PrepareResourceMethods

  setup :create_base_dir
  teardown :delete_base_dir

  # ---------- #
  test 'Test search_file_path' do
    assert_equal(TemplateManager::search_file_path(type: 'html', name: 'test1.css', 
                                                   base_dir: @@template_dir), 
                 "#{@@template_dir}/html/test1.css")
    assert_equal(TemplateManager::search_file_path(type: 'word', name: 'test2.dotx', 
                                                   base_dir: @@template_dir), 
                 "#{@@template_dir}/word/test2.dotx")
  end

  test 'Test error of search_file_path' do
    assert_raise(StandardError) do
      TemplateManager::search_file_path(type: 'not_exist', name: 'test1.css',
                                        base_dir: @@template_dir) 
    end
    assert_raise(StandardError) do
      TemplateManager::search_file_path(type: 'html', name: 'not_exist', 
                                        base_dir: @@template_dir) 
    end
  end

  # ---------- #
  def compare_templates_list(got, expected)
    assert_equal(got.length, expected.length)
    got.each { |key, value| assert_equal(value.sort, expected[key].sort) }
  end

  test 'Test get_templates_list' do
    compare_templates_list(TemplateManager::get_templates_list(type: 'html', base_dir: @@template_dir),
                 { 'html' => ['test1.css', 'test2.css', 'test3.css'] })
    compare_templates_list(TemplateManager::get_templates_list(type: 'word', base_dir: @@template_dir),
                 { 'word' => ['test1.dotx', 'test2.dotx'] })
    compare_templates_list(TemplateManager::get_templates_list(base_dir: @@template_dir),
                 { 'html' => ['test1.css', 'test2.css', 'test3.css'], 
                   'word' => ['test1.dotx', 'test2.dotx'] })
  end

  test 'Test error of get_templates_list' do
    assert_raise(StandardError) do
      TemplateManager::get_templates_list(type: 'not_exist', base_dir: @@template_dir)
    end
  end
end
