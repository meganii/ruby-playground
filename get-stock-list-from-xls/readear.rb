require 'json'
require 'spreadsheet'

book = Spreadsheet.open('data_j.xls')
sheet = book.worksheet('Sheet1')

stock = {}
sheet.each do |row|
  stock[row[1].to_i] = {
    'code' => row[1].to_i,
    'name' => row[2],
    'category' => row[3],
    'industry_code' => row[4],
    'industry_classification' => row[5]
  }
end

File.open('stock_list.json', 'w') do |f|
  f.write(JSON.pretty_generate(stock))
end
