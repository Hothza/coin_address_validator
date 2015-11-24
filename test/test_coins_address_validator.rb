require 'minitest_helper'

class TestCoinsAddressValidator < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::CoinsAddressValidator::VERSION
  end

  def test_if_correct_bitcoin_address_is_valid
    # Some random bitcoin addresses
    addr = [
      "197TP6U2ubn25ZwqgMZBm9X7HzUSpuXLeN",
      "1UioHrhjgU9bFxAPHAyEDFEbZWW5pyHu3",
      "1CbmQErmfDw3VK51TezdSQ1RnANMcUz6Fw",
      "12BBghPcZAyMBBWfrt4Kv6tfEFy66aEUq9",
      "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy"
    ]
    
    v = CoinsAddressValidator::Validator.new
    
    addr.each do |a|
      assert v.is_address_valid?(a)
    end
  end

  def test_if_incorrect_bitcoin_address_is_not_valid
    addr = [
      "$9@TP6U2ubn25ZwqgMZBm9X7HzUSpuXL!N", # not BASE58
      "3aioHrhjgU9bfxAPwAeEDFEbZWW5pyHu3", # Invalid checksum
    ]
    
    v = CoinsAddressValidator::Validator.new
    
    assert_raises ArgumentError do
      v.is_address_valid?(addr[0])
    end
    
    assert !v.is_address_valid?(addr[1])
  end

  def test_if_correct_bitcoin_address_has_correct_info
    # Some random bitcoin addresses
    addr = [
      "197TP6U2ubn25ZwqgMZBm9X7HzUSpuXLeN",
      "1UioHrhjgU9bFxAPHAyEDFEbZWW5pyHu3",
      "1CbmQErmfDw3VK51TezdSQ1RnANMcUz6Fw",
      "12BBghPcZAyMBBWfrt4Kv6tfEFy66aEUq9",
    ]
    
    v = CoinsAddressValidator::Validator.new
    
    addr.each do |a|
      info = v.get_address_info(a)
      assert info[:valid]
      assert_equal 'BTC', info[:info][:symbol]
      assert_equal 'mainnet', info[:info][:network]
      assert_equal 'Pay-to-PubkeyHash', info[:info][:type]
    end

    info = v.get_address_info("3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy")
    assert info[:valid]
    assert_equal 'BTC', info[:info][:symbol]
    assert_equal 'mainnet', info[:info][:network]
    assert_equal 'Pay-to-Script-Hash', info[:info][:type]
  end

  def test_if_incorrect_bitcoin_address_has_empty_info
    addr = [
      "$9@TP6U2ubn25ZwqgMZBm9X7HzUSpuXL!N", # not BASE58
      "3aioHrhjgU9bfxAPwAeEDFEbZWW5pyHu3", # Invalid checksum
    ]
    
    v = CoinsAddressValidator::Validator.new
    
    assert_raises ArgumentError do
      v.get_address_info(addr[0])
    end
    
    info = v.get_address_info(addr[1])
    assert !info[:valid]
    assert info[:info].empty?
  end

end
