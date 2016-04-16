require 'rake/testtask'

desc 'Run test_unit based test'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = Dir["test/test*.rb"]
  t.verbose = true
end
