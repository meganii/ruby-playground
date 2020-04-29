require 'json'
require 'csv'

csv_data = CSV.read('data.csv')

stock = {}
csv_data.each do |data|
  stock[data[0]] = {
    code: data[0],
    name: data[2],
    number: data[3],
    avgBuyPrice: data[4],
  }
end

File.open('stock_list.json', 'w') do |f|
  f.write(JSON.pretty_generate(stock))
end
