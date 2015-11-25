# Copyright (c) 2015, Hothza
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
      assert v.is_address_valid?(a), "Assertion failed on: #{a}"
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
      assert info[:valid], "Assertion failed on: #{a}"
      assert !info[:info].empty?, "Assertion failed on: #{a}"
      assert_equal 'BTC', info[:info][:symbol], "Assertion failed on: #{a}"
      assert_equal 'mainnet', info[:info][:network], "Assertion failed on: #{a}"
      assert_equal 'Pay-to-PubkeyHash', info[:info][:type], "Assertion failed on: #{a}"
    end

    info = v.get_address_info("3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy")
    assert info[:valid]
    assert_equal 'BTC', info[:info][:symbol]
    assert_equal 'mainnet', info[:info][:network]
    assert_equal 'Pay-to-Script-Hash', info[:info][:type]
  end

  def test_if_incorrect_coin_address_has_empty_info
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
  
  def test_if_correct_namecoin_address_is_valid
    # Some random generated addresses
    addr = [
      "MvehQ1RGiq7ja4cNpJscaoFb6mUbxEmqys",
      "NEnEw85mLNCNnrBEEyf1bHC8bvmBZREC4F",
      "N8wMqJLkofFLDn5ZuAd3fcBzcwth8SH7Rr",
      "NDCgTe7BHMfzECnm136rAtgjxVTV9QAnR3",
      "Mxvdj4VjPtcDMAGbj66VEybpd2i9TPzdsn"
    ]
        
    v = CoinsAddressValidator::Validator.new
    
    addr.each do |a|
      assert v.is_address_valid?(a), "Assertion failed on: #{a}"
    end
  end

  def test_if_correct_namecoin_address_has_correct_info
    # Some random generated addresses
    addr = [
      "MvehQ1RGiq7ja4cNpJscaoFb6mUbxEmqys",
      "NEnEw85mLNCNnrBEEyf1bHC8bvmBZREC4F",
      "N8wMqJLkofFLDn5ZuAd3fcBzcwth8SH7Rr",
      "NDCgTe7BHMfzECnm136rAtgjxVTV9QAnR3",
      "Mxvdj4VjPtcDMAGbj66VEybpd2i9TPzdsn"
    ]
        
    v = CoinsAddressValidator::Validator.new
    
    addr.each do |a|
      info = v.get_address_info(a)
      assert info[:valid], "Assertion failed on: #{a}"
      assert !info[:info].empty?, "Assertion failed on: #{a}"
      assert_equal 'NMC', info[:info][:symbol], "Assertion failed on: #{a}"
      assert_equal 'mainnet', info[:info][:network], "Assertion failed on: #{a}"
      assert_equal 'Pay-to-PubkeyHash', info[:info][:type], "Assertion failed on: #{a}"
    end
  end

  def test_if_correct_primecoin_address_is_valid
    # Some random generated addresses
    addr = [
      "Ac2wHkdww4GEsN9pkVn4bCiLpSRAF5y65E",
      "AbUS8yV76i3P8AQ5ucYTRzEEXnHVE852iB",
      "ASiiDNu3QoqE3tbR5okuE4F6jaCVUFCNTz",
      "AZYsE9ivNbPSPPAxQxXHbgFHXbUmWkgRht",
      "AcjsH1j9nXt9LPGzrKKHVXxmPeLaWZCmzz"
    ]
        
    v = CoinsAddressValidator::Validator.new
    
    addr.each do |a|
      assert v.is_address_valid?(a), "Assertion failed on: #{a}"
    end
  end

  def test_if_correct_primecoin_address_has_correct_info
    # Some random generated addresses
    addr = [
      "Ac2wHkdww4GEsN9pkVn4bCiLpSRAF5y65E",
      "AbUS8yV76i3P8AQ5ucYTRzEEXnHVE852iB",
      "ASiiDNu3QoqE3tbR5okuE4F6jaCVUFCNTz",
      "AZYsE9ivNbPSPPAxQxXHbgFHXbUmWkgRht",
      "AcjsH1j9nXt9LPGzrKKHVXxmPeLaWZCmzz"
    ]
        
    v = CoinsAddressValidator::Validator.new
    
    addr.each do |a|
      info = v.get_address_info(a)
      assert info[:valid], "Assertion failed on: #{a}"
      assert !info[:info].empty?, "Assertion failed on: #{a}"
      assert_equal 'XPM', info[:info][:symbol], "Assertion failed on: #{a}"
      assert_equal 'mainnet', info[:info][:network], "Assertion failed on: #{a}"
      assert_equal 'Pay-to-PubkeyHash', info[:info][:type], "Assertion failed on: #{a}"
    end
  end

  def test_if_correct_peercoin_address_is_valid
    # Some random generated addresses
    addr = [
      "PDwNitjvMpLHyCgScqgUXn2J7YMe1cCw2L",
      "PBw216TTBjUb2fgW8fXavn42pWmaTBVfcu",
      "PCA7QPrtWUpKvVFHAjKo3Dka6dzaKo8KvH",
      "PEBiGGncpvDFM5XURTgD7kPyGu97w7KTsT",
      "PCNDBXsvkZ5Y6a52GUeFNcjno2mS7nTNGU"
    ]
        
    v = CoinsAddressValidator::Validator.new
    
    addr.each do |a|
      assert v.is_address_valid?(a), "Assertion failed on: #{a}"
    end
  end

  def test_if_correct_peercoin_address_has_correct_info
    # Some random generated addresses
    addr = [
      "PDwNitjvMpLHyCgScqgUXn2J7YMe1cCw2L",
      "PBw216TTBjUb2fgW8fXavn42pWmaTBVfcu",
      "PCA7QPrtWUpKvVFHAjKo3Dka6dzaKo8KvH",
      "PEBiGGncpvDFM5XURTgD7kPyGu97w7KTsT",
      "PCNDBXsvkZ5Y6a52GUeFNcjno2mS7nTNGU"
    ]
        
    v = CoinsAddressValidator::Validator.new
    
    addr.each do |a|
      info = v.get_address_info(a)
      assert info[:valid], "Assertion failed on: #{a}"
      assert !info[:info].empty?, "Assertion failed on: #{a}"
      assert_equal 'PPC', info[:info][:symbol], "Assertion failed on: #{a}"
      assert_equal 'mainnet', info[:info][:network], "Assertion failed on: #{a}"
      assert_equal 'Pay-to-PubkeyHash', info[:info][:type], "Assertion failed on: #{a}"
    end
  end

  def test_if_correct_dash_address_is_valid
    # Some random generated addresses
    addr = [
      "XjTvuqggqa9PR2kp1N2qxyrCNWMK2a9RKX",
      "Xt9CuBKUq5pkSZFioyUSbcKqB1esstbK5s",
      "XgcU4xnUJWqo2eweeCx7uieQUTaUDVPRxd",
      "Xrcup1AcKxkp3LLGoyt3deJHKNDpv1b47Y",
      "XmtVGcfP5Kr3mjA27VugnxZ3cKKTt5nyQ2"
    ]
        
    v = CoinsAddressValidator::Validator.new
    
    addr.each do |a|
      assert v.is_address_valid?(a), "Assertion failed on: #{a}"
    end
  end

  def test_if_correct_dash_address_has_correct_info
    # Some random generated addresses
    addr = [
      "XjTvuqggqa9PR2kp1N2qxyrCNWMK2a9RKX",
      "Xt9CuBKUq5pkSZFioyUSbcKqB1esstbK5s",
      "XgcU4xnUJWqo2eweeCx7uieQUTaUDVPRxd",
      "Xrcup1AcKxkp3LLGoyt3deJHKNDpv1b47Y",
      "XmtVGcfP5Kr3mjA27VugnxZ3cKKTt5nyQ2"
    ]
        
    v = CoinsAddressValidator::Validator.new
    
    addr.each do |a|
      info = v.get_address_info(a)
      assert info[:valid], "Assertion failed on: #{a}"
      assert !info[:info].empty?, "Assertion failed on: #{a}"
      assert_equal 'DASH', info[:info][:symbol], "Assertion failed on: #{a}"
      assert_equal 'mainnet', info[:info][:network], "Assertion failed on: #{a}"
      assert_equal 'Pay-to-PubkeyHash', info[:info][:type], "Assertion failed on: #{a}"
    end
  end  

  def test_if_correct_dogecoin_address_is_valid
    # Some random generated addresses
    addr = [
      "DBbCFUZEe6r7yAd8ifMSPWLpsGgPp5bnVQ",
      "DBzog75anP3jcyuGjmJioDByQgZgQZLwhu",
      "DKyXGVBPmy7qRC3HCwcCdq2m8S9Tzk3rVK",
      "DM256zsR179mSVZ9XhKbbPv6nXXSEytRXp",
      "DTBnXWkhnx7mDffmoxYatrK3dbAtCpvx5k"
    ]
        
    v = CoinsAddressValidator::Validator.new
    
    addr.each do |a|
      assert v.is_address_valid?(a), "Assertion failed on: #{a}"
    end
  end

  def test_if_correct_dogecoin_address_has_correct_info
    # Some random generated addresses
    addr = [
      "DBbCFUZEe6r7yAd8ifMSPWLpsGgPp5bnVQ",
      "DBzog75anP3jcyuGjmJioDByQgZgQZLwhu",
      "DKyXGVBPmy7qRC3HCwcCdq2m8S9Tzk3rVK",
      "DM256zsR179mSVZ9XhKbbPv6nXXSEytRXp",
      "DTBnXWkhnx7mDffmoxYatrK3dbAtCpvx5k"
    ]
        
    v = CoinsAddressValidator::Validator.new
    
    addr.each do |a|
      info = v.get_address_info(a)
      assert info[:valid], "Assertion failed on: #{a}"
      assert !info[:info].empty?, "Assertion failed on: #{a}"
      assert_equal 'DOGE', info[:info][:symbol], "Assertion failed on: #{a}"
      assert_equal 'mainnet', info[:info][:network], "Assertion failed on: #{a}"
      assert_equal 'Pay-to-PubkeyHash', info[:info][:type], "Assertion failed on: #{a}"
    end
  end  

  def test_if_correct_feathercoin_address_is_valid
    # Some random generated addresses
    addr = [
      "6vQrFbaponzjfHvPsqXiFRb68WsuJfK9A3",
      "6vGeZx41BpT8o4RCd5hyTu5aLTVakSPszy",
      "6oJFdDpJJqymbkcbkfpDDPbeLu99KzgLsR",
      "6vvgh6YZY8mD7FTSehvk7fXGfYPFYGiJoq",
      "6n2FZqSVV9d4xbgVDHGzjLjvvdTMmuA8hg"
    ]
        
    v = CoinsAddressValidator::Validator.new
    
    addr.each do |a|
      assert v.is_address_valid?(a), "Assertion failed on: #{a}"
    end
  end

  def test_if_correct_feathercoin_address_has_correct_info
    # Some random generated addresses
    addr = [
      "6vQrFbaponzjfHvPsqXiFRb68WsuJfK9A3",
      "6vGeZx41BpT8o4RCd5hyTu5aLTVakSPszy",
      "6oJFdDpJJqymbkcbkfpDDPbeLu99KzgLsR",
      "6vvgh6YZY8mD7FTSehvk7fXGfYPFYGiJoq",
      "6n2FZqSVV9d4xbgVDHGzjLjvvdTMmuA8hg"
    ]
        
    v = CoinsAddressValidator::Validator.new
    
    addr.each do |a|
      info = v.get_address_info(a)
      assert info[:valid], "Assertion failed on: #{a}"
      assert !info[:info].empty?, "Assertion failed on: #{a}"
      assert_equal 'FTC', info[:info][:symbol], "Assertion failed on: #{a}"
      assert_equal 'mainnet', info[:info][:network], "Assertion failed on: #{a}"
      assert_equal 'Pay-to-PubkeyHash', info[:info][:type], "Assertion failed on: #{a}"
    end
  end 

end
