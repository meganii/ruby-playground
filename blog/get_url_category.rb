require 'yaml'
require 'csv'
require 'date'

def read_frontmatter (filepath)
  open(filepath) do |f|
    thing = YAML.load_file(f)
  end  
end

CSV.open('url_category.csv','w') do |csvfile|

  csvfile << ['URL', 'Title', 'Category']

  Dir.glob('./content/blog/*.md').sort.each do |mdfile|
    begin
      fm = read_frontmatter(mdfile)
      d = fm['date']
      dfmt = ''
      if d.instance_of?(String)
        fmt = d.slice(0,10).split('-')
        dfmt = fmt[0] + "/" + fmt[1] + "/" + fmt[2]
        puts dfmt
      elsif d.instance_of?(Date)
        dfmt = fm['date'].strftime("%Y/%m/%d")
        puts dfmt
      elsif d.instance_of?(Time)
        dfmt = fm['date'].strftime("%Y/%m/%d")
        puts dfmt
      else
        puts "else"
      end
      csvfile << ["/blog/#{dfmt}/#{fm["slug"]}/", fm['title'], fm["category"][0]]
    rescue => exception
      puts exception
    end
  end

end

