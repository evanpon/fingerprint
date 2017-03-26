require 'test_helper'

class SemanticsClientTest < ActiveSupport::TestCase

  test 'can successfully retrieve data from Semantics' do
    client = SemanticsClient.new
    VCR.use_cassette("semantics_client_test/successful_response", record: :once) do
      results = client.search_for_products('iphone', 1)
      assert_can_parse_products_from_json(results['products'])
    end
  end

  
  test 'can handle missing or present images' do
    client = SemanticsClient.new
    VCR.use_cassette("semantics_client_test/missing_image", record: :once) do
      results = client.search_for_products('monitor', 1)
      assert_nil(results['products'].first['image'])
      assert_match(/https?:\/\/.*\..*/, results['products'][1]['image'])
    end
  end

  test 'can handle missing descriptions' do
    client = SemanticsClient.new
    VCR.use_cassette("semantics_client_test/missing_description", record: :once) do
      results = client.search_for_products('monitor', 1)
      assert_equal('', results['products'].first['description'])
    end
  end

  test 'can handle multiple sellers' do
    client = SemanticsClient.new
    VCR.use_cassette("semantics_client_test/multiple_sellers", record: :once) do
      results = client.search_for_products('cord', 1)
      sellers = results['products'].first['sellers']
      assert_equal(3, sellers.count)
      sellers.each do |seller|
        assert_not_empty(seller['name'])
        assert_match(/https?:\/\/.*\..*/, seller['url'])
        assert_match(/\d+\.\d+/, seller['price'])
      end
    end
  end

  test 'can handle a product with 0 results' do
    client = SemanticsClient.new
    VCR.use_cassette("semantics_client_test/zero_results", record: :once) do
      results = client.search_for_products('aoeuthao2ntaohue', 1)
      assert_equal(0, results['products'].count)
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
