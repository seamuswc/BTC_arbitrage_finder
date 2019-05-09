
require 'openssl'
require 'json'
require 'net/http'
require 'uri'

class Binance

  def initialize
    
    @url = "https://api.binance.com"

  end

  def get_name
    return "Binance"
  end


  def get_symbols
    endpoint = "/api/v3/ticker/price"
    uri = @url + endpoint
    uri = URI(uri)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    pairs = Array.new
    data.each do |pair|
      if pair["symbol"].include? "BTC"
        pairs << pair["symbol"]
      end
    end
    pairs
  end

  def get_price(pair)
    query = URI.encode_www_form("symbol" => pair)
    endpoint = "/api/v3/ticker/price"
    uri = @url + endpoint + '?' + query
    uri = URI(uri)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    if data["price"] == nil then
      get_price(pair)
    else
      data["price"]
    end

  end

  def get_time
    endpoint = "/api/v1/time"
    uri = @url + endpoint
    uri = URI(uri)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    data["serverTime"]
  end

  def get_amount(asset)

    timestamp = get_time
    query = URI.encode_www_form("timestamp"=> timestamp)
    signature = sig(query)
    query = URI.encode_www_form("timestamp"=> timestamp, "signature" => signature)
    endpoint = "/api/v3/account"
    uri = @url + endpoint + '?' + query

    uri = URI(uri)
    req = Net::HTTP::Get.new(uri)
    req['X-MBX-APIKEY'] = @api_key

    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end


    data = JSON.parse(res.body)
    data = data["balances"]
    data.each do |x|
      if x["asset"] == asset then
        return asset["free"]
      end
    end

  end

  #POST /wapi/v3/withdraw.html (HMAC SHA256)
  def send_crypto(asset)

    timestamp = get_time
    query = URI.encode_www_form("asset" => asset, "address" =>  @send_to_address, "amount" => get_amount(asset), "timestamp"=> timestamp)
    signature = sig(query)
    query = URI.encode_www_form("asset" => asset, "address" => @send_to_address, "amount" => get_amount(asset), "timestamp"=> timestamp, "signature" => signature)
    endpoint = "/wapi/v3/withdraw.html"
    uri = @url + endpoint + '?' + query

    uri = URI(uri)
    req = Net::HTTP::Post.new(uri)
    req['X-MBX-APIKEY'] = @api_key

    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end

    puts res.body

  end

  def sig(query)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA256.new, @api_secret, query)
  end


end # End Class
