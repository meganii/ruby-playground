require 'open-uri'

ticker = '2928-S'
url = "http://k-db.com/stocks/#{ticker}?download=csv"

open(url, 'r:shift_jis') do |res|
  File.open("#{ticker}.csv", 'w') do |f|
    f.write(res.read.encode('utf-8'))
  end
end
