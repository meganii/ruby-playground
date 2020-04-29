require './stocks/db_stock'
require './stocks/google_finance'

stocks = %w[
  2597
  3048
  3395
  3598
  3788
  4355
  4665
  4755
  6750
  7962
  8306
  8798
  8877
  9449
  9861
  4527
  7984
  7921
  1789
  4912
]

# db_stock = DBStock.new
gf = GoogleFinance.new
stocks.each do |ticker|
  price = gf.get_current_price(ticker, 'TYO')
  puts "#{ticker}: #{price}"
  break
end
