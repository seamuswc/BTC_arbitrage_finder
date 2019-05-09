
require 'openssl'
require 'json'
require 'net/http'
require 'uri'


class Digifinex

  def initialize

    @api_key = ""


  end

  def get_name
    return "Digifinex"
  end


  def get_symbols
  	#https://openapi.digifinex.com/v2/ticker?apiKey=15cd30eb735745
    url = URI("https://openapi.digifinex.com/v2/ticker?apiKey=#{@api_key}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    data = JSON.parse(response.read_body)
    pairs = Array.new
    data["ticker"].each do |pair|
      if pair[0].downcase.include? "btc"
      	x = pair[0].delete_prefix("btc_")
      	x = x << "btc"
        pairs << x.upcase
      end
    end

   pairs

  end

  def get_price(pair)
  	x = pair.delete_suffix("BTC")
  	x = x.prepend("btc_")
  	x = x.downcase

    url = URI("https://openapi.digifinex.com/v2/ticker?symbol=#{x}&apiKey=#{@api_key}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    data = JSON.parse(response.read_body)
    data["ticker"][x]["last"]

     if data["ticker"][x]["last"] == nil then
      get_price(pair)
    else
      data["ticker"][x]["last"]
    end

  end







end
