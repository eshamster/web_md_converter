require 'fileutils'

module PrepareResourceMethods
  @@base_dir = File.dirname(__FILE__) + '/temp'
  @@template_dir = @@base_dir + '/templates'

  def create_base_dir
    unless FileTest.exist?(@@base_dir)
      FileUtils.cp_r(@@src_dir, @@base_dir)
    else
      raise "The temp directory '#{@@base_dir}' is already exist"
    end
  end

  def delete_base_dir
    FileUtils.rm_r(@@base_dir) if FileTest.exist?(@@base_dir)
  end

  private

  @@src_dir = File.dirname(__FILE__) + '/resource'
end
