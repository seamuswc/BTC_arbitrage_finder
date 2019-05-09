
require 'openssl'
require 'json'
require 'net/http'
require 'uri'
require 'bigdecimal'




class Huobi

  def initialize

    

  end

  def get_name
    return "Huobi"
  end


  def get_symbols
    url = URI("https://api.huobi.com/v1/common/symbols")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    data = JSON.parse(response.read_body)
    pairs = Array.new

    data["data"].each do |pair|
      if pair["quote-currency"].downcase.include? "btc"
      	x = pair["base-currency"] << "btc"
        pairs << x.upcase
      end

    end

   pairs

  end

  def get_price(pair)
  	x = pair.downcase

    url = URI("https://api.huobi.com/market/trade?symbol=#{x}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    data = JSON.parse(response.read_body)
    data = data["tick"]["data"].first["price"].to_f





  end







end
