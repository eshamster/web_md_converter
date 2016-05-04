require 'test/unit'
require 'fileutils'
require_relative '../template_manager'

module PrepareResourceMethods
  @@base_dir = File.dirname(__FILE__) + '/temp'
  @@template_dir = @@base_dir + '/templates'

  def create_base_dir
    unless FileTest.exist?(@@base_dir)
      FileUtils.cp_r(@@src_dir, @@base_dir)
      TemplateManager::set_base_dir! @@template_dir
    else
      raise "The temp directory '#{@@base_dir}' is already exist"
    end
  end

  def delete_base_dir
    FileUtils.rm_r(@@base_dir) if FileTest.exist?(@@base_dir)
    TemplateManager::reset_base_dir!
  end

  def unregistered_template_path
    @@base_dir + '/sample.md'
  end
  
  def unregistered_template_file
    Rack::Test::UploadedFile.new(unregistered_template_path)
  end

  private

  @@src_dir = File.dirname(__FILE__) + '/_resource'
end

module Test::Unit::Assertions

  def equal_content?(got, expected)
    if got.is_a?(Hash) && expected.is_a?(Hash)
      return got.all? { |k, v| equal_content? v, expected[k] }
    elsif got.is_a?(Array) && expected.is_a?(Array)
      return got.length == expected.length &&
             got.sort.zip(expected.sort).all? { |x, y| equal_content? x, y }
    else
      return got == expected
    end
  end

  # Check if the two arrays or hashes have same contents.
  # This ignores order of their contents
  def assert_same_content(got, expected)
    message = "Contents are different\n#{expected} expected but was\n#{got}"
    assert(equal_content?(got, expected), message)
  end

  module_function :assert_same_content
end
