require 'test_helper'

class SemanticsClientTest < ActiveSupport::TestCase

  test 'can successfully retrieve data from Semantics' do
    client = SemanticsClient.new
    VCR.use_cassette("successful_response", record: :once) do
      products = client.search_for_products('iphone', 1)
      assert_can_parse_products_from_json(products)
    end
  end

  
  test 'can handle missing or present images' do 
    client = SemanticsClient.new
    VCR.use_cassette("missing_image", record: :once) do
      products = client.search_for_products('monitor', 1)
      assert_nil(products.first['image'])
      assert_match(/https?:\/\/.*\..*/, products[1]['image'])
    end
  end
  
  test 'can handle missing descriptions' do 
    client = SemanticsClient.new
    VCR.use_cassette("missing_description", record: :once) do
      products = client.search_for_products('monitor', 1)
      assert_equal('', products.first['description'])
    end
  end
  
  def assert_can_parse_products_from_json(products)
    assert_equal(10, products.count)
    products.each do |product|
      assert_not_empty(product['name'])
      assert_not_empty(product['description'])
      assert_match(/\d+/, product['price'])
      product['sellers'].each do |seller|
        assert_not_empty(seller['name'])
        assert_not_empty(seller['url'])
        assert_match(/\d+/, seller['price'])
      end
    end
  end
  
end
