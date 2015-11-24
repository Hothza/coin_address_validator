require "coins_address_validator/version"
require 'base58'
require 'digest'

module CoinsAddressValidator
  class Validator
    def get_address_info(address)
      decoded = decode(address)
      if is_checksum_valid?(decoded)
        { :valid => true, :info => NETWORKS[decoded[:version].to_i] }
      else
        { :valid => false, :info => {} }
      end
    end
    
    def is_address_valid?(address)
      if !address.nil? && !address.empty?
        is_checksum_valid?(decode(address))
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
