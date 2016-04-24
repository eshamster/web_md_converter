require 'test/unit'
require_relative '../type_manager'

class TestTypeManager < Test::Unit::TestCase
  sub_test_case 'Test the factory and readers of each TypeManager' do
    data('Html' => ['html', 'text/html', 'html'],
         'Word' => ['word', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'docx'])
    def test_use_data(data)
      manager_type, content_type, specifier = data
      manager = TypeManager::create(manager_type)
      assert_equal manager.content_type, content_type
      assert_equal manager.specifier, specifier
    end
    test 'Check error' do
      assert_raise(ArgumentError) { TypeManager::create('not_exist'); }
    end
  end

  test 'Test validation' do
    existing_type = TypeManager::all_supported_types[0]
    assert TypeManager::is_valid?(existing_type)
    assert ! TypeManager::is_valid?('not_exist')
  end
end
