require 'faraday'
require 'date'

class GoogleFinance
  def get_price(code, market, period, lastdate, interval = 86_400)
    response = prices_response(code, market, period, lastdate, interval)
    lines = response.body.each_line.map(&:chomp)
    columns = lines[4].split('=')[1].split(',')
    prices = lines.slice(8..lines.size)
    calc_date(prices, columns)
  end

  def prices_response(code, market, period, lastdate, interval = 86_400)
    params = {
      q:  code,     # code
      i:  interval, # interval
      x:  market,   # market
      p:  period,   # period
      ts: lastdate  # lastdate
    }

    conn = Faraday.new(url: 'https://www.google.com/finance/getprices') do |builder|
      builder.request  :url_encoded
      builder.adapter  :net_http
    end

    response = conn.get { |req| req.params = params }
    p response
    response
  end

  def get_current_price(code, market)
    prices = get_price(code, market, '1Y', DateTime.now.to_datetime, 86_400)
    prices[prices.size - 1][1]
  end

  private

  def calc_date(prices, columns)
    base_date = base_date(prices)
    fst_cols = prices[0].split(',')

    result = []
    result << columns
    result << [base_date.strftime('%Y-%m-%d'), fst_cols[1], fst_cols[2], fst_cols[3], fst_cols[4], fst_cols[5]]

    prices.slice(1..prices.size).each do |price|
      cols = price.split(',')
      date = base_date + cols[0].to_i
      result << [date.strftime('%Y-%m-%d'), cols[1], cols[2], cols[3], cols[4], cols[5]]
    end
    result
  end

  def base_date(prices)
    first_col = prices[0].split(',')
    base_date = Time.at(first_col[0].delete('a').to_i)
    Date.parse(base_date.strftime('%Y-%m-%d'), '%Y-%m-%d')
  end
end

gf = GoogleFinance.new
# prices = gf.get_price('7183', 'TYO', '1Y', '2017-08-08')

# prices.each do |price|
#   p price
# end

current_price = gf.get_current_price('8411', 'TYO')
p "current_price: #{current_price}"
