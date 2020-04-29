require 'open-uri'

class DBStock
  def initialize; end

  # 現在株価取得
  # @param [String] ticker 株価コード
  # @return [String] 現在株価
  def get_current_price(ticker)
    prices = get_prices(ticker)
    prices[1][4]
  end

  # 株価リスト取得
  # @param [String] ticker 株価コード
  # @return [String] 現在株価
  def get_prices(ticker)
    url = "http://k-db.com/stocks/#{ticker}?download=csv"
    prices = []
    open(url, 'r:shift_jis') do |f|
      f.each_line { |line| prices << line.encode('utf-8').chomp.split(',') }
    end
    prices
  end

  # CSV保存
  # @param [String] ticker 株価コード
  def to_csv(ticker)
    ticker = '7183-T'
    url = "http://k-db.com/stocks/#{ticker}?download=csv"
    open(url, 'r:shift_jis') do |res|
      File.open("#{ticker}.csv", 'w') do |f|
        f.write(res.read.encode('utf-8'))
      end
    end
  end
end

# ticker = '3237-T'
# db_stock = DBStock.new
# p db_stock.get_prices(ticker)
# p db_stock.get_current_price(ticker)
