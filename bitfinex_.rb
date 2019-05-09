
require 'bitfinex'
require 'openssl'
require 'json'
require 'net/http'
require 'uri'


class Bitfinex_

  def initialize

    

  end

  def get_name
    return "Bitfinex"
  end

  def get_symbols
    url = URI("https://api.bitfinex.com/v1/symbols")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    data = JSON.parse(response.read_body)
    pairs = Array.new
    data.each do |pair|
      if pair.downcase.include? "btc"
        pairs << pair.upcase
      end
    end
     pairs
  end

  def get_price(pair)
    url = URI("https://api.bitfinex.com/v1/pubticker/#{pair}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    data = JSON.parse(response.read_body)

     if data["mid"] == nil then
      get_price(pair)
    else
      data["mid"]
    end

  end





end # End Class
