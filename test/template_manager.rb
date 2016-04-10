require 'test/unit'
require 'fileutils'
require_relative '../template_manager.rb'

module PrepareMethods
  @@base_dir = File.dirname(__FILE__) + '/temp'
  @@src_dir = File.dirname(__FILE__) + '/resource/templates'
  @@dst_dir = @@base_dir + '/templates'

  def create_base_dir
    unless FileTest.exist?(@@base_dir)
      FileUtils.mkdir_p(@@base_dir)
      FileUtils.cp_r(@@src_dir, @@dst_dir)
    else
      raise "The temp directory '#{@@base_dir}' is already exist"
    end
  end

  def delete_base_dir
    FileUtils.rm_r(@@base_dir) if FileTest.exist?(@@base_dir)
  end
end

class TestTemplateManager < Test::Unit::TestCase
  include PrepareMethods

  setup :create_base_dir
  teardown :delete_base_dir

  # ---------- #
  test 'Test search_file_path' do
    assert_equal(TemplateManager::search_file_path(type: 'html', name: 'test1.css', 
                                                   base_dir: @@dst_dir), 
                 "#{@@dst_dir}/html/test1.css")
    assert_equal(TemplateManager::search_file_path(type: 'word', name: 'test2.dotx', 
                                                   base_dir: @@dst_dir), 
                 "#{@@dst_dir}/word/test2.dotx")
  end

  test 'Test error of search_file_path' do
    assert_raise(StandardError) do
      TemplateManager::search_file_path(type: 'not_exist', name: 'test1.css',
                                        base_dir: @@dst_dir) 
    end
    assert_raise(StandardError) do
      TemplateManager::search_file_path(type: 'html', name: 'not_exist', 
                                        base_dir: @@dst_dir) 
    end
  end

  # ---------- #
  def compare_templates_list(got, expected)
    assert_equal(got.length, expected.length)
    got.each { |key, value| assert_equal(value.sort, expected[key].sort) }
  end

  test 'Test get_templates_list' do
    compare_templates_list(TemplateManager::get_templates_list(type: 'html', base_dir: @@dst_dir),
                 { 'html' => ['test1.css', 'test2.css', 'test3.css'] })
    compare_tempates_list(TemplateManager::get_templates_list(type: 'word', base_dir: @@dst_dir),
                 { 'word' => ['test1.dotx', 'test2.dotx'] })
  end

  test 'Test error of get_templates_list' do
    assert_raise(StandardError) do
      TemplateManager::get_templates_list(type: 'not_exist', base_dir: @@dst_dir)
    end
  end
end
