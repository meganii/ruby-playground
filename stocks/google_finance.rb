require 'faraday'
require 'date'

params = {
  q: 3237,   # code
  i: 86_400, # interval
  x: 'TYO',  # market
  p: '1Y',   # period
  ts: DateTime.now.to_datetime # lastdate
}

conn = Faraday.new(url: 'https://www.google.com/finance/getprices') do |builder|
  builder.request  :url_encoded
  builder.adapter  :net_http
end

response = conn.get do |req|
  req.params = params
end

lines = response.body.each_line.map(&:chomp)
columns = lines[4].split('=')[1].split(',')
prices = lines.slice(8..lines.size)

fst_cols = prices[0].split(',')
timestamp = fst_cols[0].delete('a')
first_date = Time.at(timestamp.to_i)

result = []
result << columns
result << [first_date.strftime('%Y-%m-%d'),
           fst_cols[1], fst_cols[2], fst_cols[3], fst_cols[4], fst_cols[5]]

prices.slice(1..prices.size).each do |price|
  cols = price.split(',')
  date = Date.parse(first_date.strftime('%Y-%m-%d'), '%Y-%m-%d') + cols[0].to_i
  result << [date.strftime('%Y-%m-%d'), cols[1],
             cols[2], cols[3], cols[4], cols[5]]
end
