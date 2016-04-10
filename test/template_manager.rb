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
  
  test 'test' do
    puts `find test/temp -type f`
  end
  test 'test2' do
    puts 234
  end
end
