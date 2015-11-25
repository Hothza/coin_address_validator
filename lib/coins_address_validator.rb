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

require "coins_address_validator/version"
require 'base58'
require 'digest'

module CoinsAddressValidator
  class Validator
    def get_address_info(address)
      if !address.nil? && !address.empty?
        decoded = decode(address)
        if has_valid_length?(address, decoded[:version].to_i(16)) && is_checksum_valid?(decoded)
          info = NETWORKS[decoded[:version].to_i(16)]
          info = {} if info.nil? # Version is not supported (yet) - return empty info for such coin
      
          return { :valid => true, :info => info }
        end
      end
      return { :valid => false, :info => {} }
    end
    
    def is_address_valid?(address)
      if !address.nil? && !address.empty?
        decoded = decode(address)
        is_checksum_valid?(decoded) && has_valid_length?(address, decoded[:version].to_i(16))
      else
        false
      end
    end
    
    private
      NETWORKS = {
        ## Bitcoin
        0x00 => { :name => 'Bitcoin', :network => 'mainnet', :symbol => 'BTC', :type => 'Pay-to-PubkeyHash' },
        0x05 => { :name => 'Bitcoin', :network => 'mainnet', :symbol => 'BTC', :type => 'Pay-to-Script-Hash' },
        0x6f => { :name => 'Bitcoin', :network => 'testnet3', :symbol => 'XTN', :type => 'Pay-to-PubkeyHash' },
        0xc4 => { :name => 'Bitcoin', :network => 'testnet3', :symbol => 'XTN', :type => 'Pay-to-Script-Hash' },
        
        ## Litecoin
        0x30 => { :name => 'Litecoin', :network => 'mainnet', :symbol => 'LTC', :type => 'Pay-to-PubkeyHash' },
        
        # Litecoin Multisig -> version will be changed after hard-fork
        # to some number which gives 'M' character in address (probably: 0x31 - 0x33)
        
        # 0x05 => { :name => 'Litecoin', :network => 'mainnet', :symbol => 'LTC', :type => 'Pay-to-Script-Hash' },
        
        # Litecoin version will be changed probably in similar way like in mainnet
        
        # 0x6f => { :name => 'Litecoin', :network => 'testnet', :symbol => 'XLT', :type => 'Pay-to-PubkeyHash' },
        # 0xc4 => { :name => 'Litecoin', :network => 'testnet', :symbol => 'XLT', :type => 'Pay-to-Script-Hash' },
        
        ## Dogecoin
        0x1e => { :name => 'Dogecoin', :network => 'mainnet', :symbol => 'DOGE', :type => 'Pay-to-PubkeyHash' },
        0x16 => { :name => 'Dogecoin', :network => 'mainnet', :symbol => 'DOGE', :type => 'Pay-to-Script-Hash' },
        0x71 => { :name => 'Dogecoin', :network => 'testnet', :symbol => 'XDT', :type => 'Pay-to-PubkeyHash' },
        #{ 0xc4 => { :name => 'Dogecoin', :network => 'testnet', :symbol => 'XDT', :type => 'Pay-to-Script-Hash' },
        
        ## DASH / DRK
        0x4c => { :name => 'DASH', :network => 'mainnet', :symbol => 'DASH', :type => 'Pay-to-PubkeyHash' },
        0x10 => { :name => 'DASH', :network => 'mainnet', :symbol => 'DASH', :type => 'Pay-to-Script-Hash' },
        0x8b => { :name => 'DASH', :network => 'testnet', :symbol => 'tDASH', :type => 'Pay-to-PubkeyHash' },
        0x13 => { :name => 'DASH', :network => 'testnet', :symbol => 'tDASH', :type => 'Pay-to-Script-Hash' },
        
        ## Feathercoin
        0x0e => { :name => 'Feathercoin', :network => 'mainnet', :symbol => 'FTC', :type => 'Pay-to-PubkeyHash' },
        0x60 => { :name => 'Feathercoin', :network => 'mainnet', :symbol => 'FTC', :type => 'Pay-to-Script-Hash'  },
        0x41 => { :name => 'Feathercoin', :network => 'testnet', :symbol => 'FTX', :type => 'Pay-to-PubkeyHash' },
        #0xc4 => { :name => 'Feathercoin', :network => 'mainnet', :symbol => 'FTX', :type => 'Pay-to-Script-Hash'  },
        
        ## Namecoin
        0x34 => { :name => 'Namecoin', :network => 'mainnet', :symbol => 'NMC', :type => 'Pay-to-PubkeyHash' },
        #0x6f => { :name => 'Namecoin', :network => 'testnet', :symbol => 'NMC', :type => 'Pay-to-PubkeyHash' },
  
        ## Peercoin 
        0x37 => { :name => 'Peercoin', :network => 'mainnet', :symbol => 'PPC', :type => 'Pay-to-PubkeyHash' },
        0x75 => { :name => 'Peercoin', :network => 'mainnet', :symbol => 'PPC', :type => 'Pay-to-Script-Hash' },
        
        ## Primecoin
        0x17 => { :name => 'Primecoin', :network => 'mainnet', :symbol => 'XPM', :type => 'Pay-to-PubkeyHash' },
        0x53 => { :name => 'Primecoin', :network => 'mainnet', :symbol => 'XPM', :type => 'Pay-to-Script-Hash' },
      }
      BASE58 = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
      LENGTH = BASE58.length
      
      def is_checksum_valid?(decoded)
        double_sha256 = (Digest::SHA256.new << (Digest::SHA256.new << [decoded[:h160]].pack('H*')).digest)
        double_sha256.hexdigest[0, 8] == decoded[:checksum]
      end
      
      def has_valid_length?(address, version)
        if version == 0
          return address.length < 35
        elsif version == 1
          return address.length == 33
        elsif version == 2
          return address.length == 33 || address.length == 34
        elsif version > 2 && version < 144
          return address.length == 34
        elsif version == 144
          return address.length == 34 || address.length == 35
        elsif version > 144 && version < 256
          return address.length == 35
        else
          return false
        end
      end
      
      def b58tos(string)
        value = 0
        prefix = 0
        string.each_char do |char|
          index = BASE58.index(char)
          raise ArgumentError, 'String passed as a parameter is not a valid BASE58 string.' if index.nil?
          value = (value * LENGTH) + index
          if value == 0
            prefix += 1
          end
        end
        
        output = value.to_s(16)
        
        # Stupid workaround for missing leading zeros
        output = "0" + output if (output.length % 2) == 1
        
        output = ("00" * prefix) + output if prefix > 0
        output
      end

      def decode(string)
        decoded = b58tos(string)
        { :version => decoded[0, 2],  :h160 => decoded[0, decoded.length - 8 ], :checksum => decoded[-8, decoded.length] }
      end
  end  
end
