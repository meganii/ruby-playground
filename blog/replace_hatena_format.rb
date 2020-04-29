# frozen_string_literal: true

BASEPATH = 'content/blog'
print 'Input filename:'
filename = gets.to_s.chop

buffer = File.open(File.join(BASEPATH, filename), 'r', &:read)
buffer.gsub!(%r{<p\>|\<\/p\>}, '')
buffer.gsub!(%r{\<\/h.+?\>}, '')
buffer.gsub!(/\<a class=\"keyword\".+?>/, '')
buffer.gsub!(/\<\/a\>/, '')
buffer.gsub!('<div class="section">', '')
buffer.gsub!(/\<\/div\>/, '')
buffer.gsub!('<h4>', '## ')
buffer.gsub!('<h5>', '### ')
buffer.gsub!('<li>', '- ')
buffer.gsub!('</li>', '')
buffer.gsub!(/\<br \/\>|\<br\>/, '')
buffer.gsub!(/\<span style=.*?\>|\<\/span\>/, '')

File.open(File.join(BASEPATH, filename), 'w') do |f|
  f.write(buffer)
end
