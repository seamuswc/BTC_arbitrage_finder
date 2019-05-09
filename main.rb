
require_relative 'binance'
require_relative 'bitfinex_'
require_relative 'digifinex' #requires api key to be added
require_relative 'huobi'

class Main

      $max_difference = {"difference" => 0 }


  def initialize

    @bitfinex = Bitfinex_.new
    @binance = Binance.new
    @huobi = Huobi.new
    @digifinex = Digifinex.new
    @exchanges = [
      @bitfinex,
      @binance,
      @huobi,
      @digifinex
    ]

  end



  def find_greatest_disparity(exchange_one, exchange_two)

    #get the common symbols
    pairs = Array.new
    symbols_one = exchange_one.get_symbols
    symbols_two = exchange_two.get_symbols
    pairs = symbols_one&symbols_two

    #get price of each and compare the difference
    pair = max = 0
    final = {"symbol" => pair}
    pairs.each do |pair|

      price_one = exchange_one.get_price(pair)
      price_two = exchange_two.get_price(pair)

      difference = (1 - price_one.to_f / price_two.to_f) * 100

      if difference > max then
        max = difference
        final["symbol"] = pair
        final["difference"] = difference
        final[exchange_one.get_name] = price_one
        final[exchange_two.get_name] = price_two
      end

    end #pair.each end

      if final["symbol"] == ( 0 or nil )|| final["difference"] == (0 or 100) || final[exchange_one.get_name] == nil || final[exchange_two.get_name] == nil then
        find_greatest_disparity(exchange_one, exchange_two)
      else
        return final
      end

  end #funciton end

  def compare_all(n=(@exchanges.length - 1), j=0, t=(@exchanges.length - 1), exchanges=@exchanges)
    puts "....."

    n.times do |i|
      result = find_greatest_disparity(@exchanges[j], @exchanges[t-i])
      if result["difference"].to_f > $max_difference["difference"].to_f then
        $max_difference = result
      end
    end

    n -= 1
    j += 1
    puts "========"
    compare_all(n, j, t, @exchanges) unless n == 0

  end

end
