# CoinsAddressValidator [![Build Status](https://travis-ci.org/Hothza/coin_address_validator.svg)](https://travis-ci.org/Hothza/coin_address_validator) [![Gem Version](https://badge.fury.io/rb/coins_address_validator.svg)](https://badge.fury.io/rb/coins_address_validator) [![Test Coverage](https://codeclimate.com/github/Hothza/coin_address_validator/badges/coverage.svg)](https://codeclimate.com/github/Hothza/coin_address_validator/coverage)

This gem allows you to check if virtual coin address is valid and retrieve information about it.

Supported coins: 
 - Bitcoin (BTC),
 - DASH (DASH),
 - Dogecoin (DOGE),
 - Litecoin (LTC),
 - Namecoin (NMC),
 - Peercoin (PPC),
 - Primecoin (XPM)

If you find this gem useful please send few coins for coffee:

- BTC: 1HRqmR2dbuHKeNWp478W77NxLzPi63QoKi
- LTC: LUzmQEYEMHxh7Q8JWh3vjW2BYCGd8VxANF
- DASH: XtPu4gA71zMdp37x3XiYdG2U25UA85Gq1w

Thank you! :)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coins_address_validator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coins_address_validator

## Usage

This gem has two public methods:
```ruby
is_address_valid?() 
```
which checks if address passed as a parameter is valid BASE58 string, has correct length
and checksum from decoded address is equal to first four bytes of SHA256(SHA256(h160))

Second one:
```ruby
get_address_info()
```
returns information about network (Bitcoin, Litecoin, etc.), network symbol and type of address. 

## Contributing

1. Fork it ( https://github.com/Hothza/coins_address_validator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
