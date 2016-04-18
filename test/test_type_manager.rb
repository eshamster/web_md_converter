require 'test/unit'
require_relative '../type_manager'

class TestTypeManager < Test::Unit::TestCase
  sub_test_case 'Test the factory and readers of each TypeManager' do
    data('Html' => ['html', 'text/html', 'html'],
         'Word' => ['word', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'docx'])
    def test_use_data(data)
      manager_type, content_type, specifier = data
      manager = TypeManager::Base::create(manager_type)
      assert_equal manager.content_type, content_type
      assert_equal manager.specifier, specifier
    end
    test 'Check error' do
      assert_raise(ArgumentError) { TypeManager::Base::create('not_exist'); }
    end
  end
end
