# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'stringex'

posts_dir       = 'content/blog/' # directory for blog files
new_post_ext    = 'md' # default new post file extension when using the new_post task

desc 'deploy to sakura from circle ci'
task :deploy_to_sakura_from_circleci do
  sh 'hugo -t hugo-zen'
  sh "rsync -e \"ssh -p #{ENV['SSH_PORT']}\" -avz --delete public/ web@#{ENV['SAKURA_IP']}:/home/web/www/meganii.com"
end

desc 'deploy_to_sakura'
task :deploy_to_sakura do
  sh 'rm -r public'
  sh 'hugo -t hugo-zen'
  sh "rsync --iconv=UTF-8-MAC,UTF-8 -e \"ssh -p #{ENV['SSH_PORT']}\" -avz --delete public/ web@#{ENV['SAKURA_IP']}:/home/web/www/meganii.com"
end

desc 'deploy_to_vagrant'
task :deploy_to_vagrant do
  sh 'rm -r public'
  sh 'hugo -t hugo-zen'
  sh "rsync --iconv=UTF-8-MAC,UTF-8 -e \"ssh -p #{ENV['SSH_PORT']}\" -avz --delete public/ web@192.168.33.33:/home/web/www/meganii.com/blog/"
end

desc "Begin a new post in #{posts_dir}"
task :new_post, :title do |_t, args|
  title = if args.title
            args.title
          else
            get_stdin('Enter a title for your post: ')
          end

  filename = "#{posts_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.#{new_post_ext}"
  if File.exist?(filename)
    abort('rake aborted!') if ask("#{filename} already exists. Do you want to overwrite?", %w[y n]) == 'n'
  end
  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts '---'
    post.puts "title: \"#{title.gsub(/&/, '&amp;')}\""
    post.puts "date: #{Time.now.strftime('%Y-%m-%dT%H:%M:%S+09:00')}"
    post.puts "lastmod: #{Time.now.strftime('%Y-%m-%dT%H:%M:%S+09:00')}"
    post.puts 'comments: true'
    post.puts "category: ['']"
    post.puts "tags: ['']"
    post.puts 'published: false'
    post.puts "slug: #{title.to_url}"
    post.puts 'img: '
    post.puts '---'
    post.puts
    post.puts '<!--more-->'
    post.puts '{{% googleadsense %}}'
  end
  sh "code #{filename}"
end

desc 'Merge posts contents'
task :merge_contents do
  require 'sanitize'

  File.open('tmp/contents.txt', 'w') do |wf|
    Dir.glob("#{posts_dir}*.*").each do |file|
      File.open(file, 'r') do |f|
        content = f.read
        if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
          data = YAML.safe_load(Regexp.last_match(1))
          next unless data['published']
        end
        content = Sanitize.clean(content, Sanitize::Config::RESTRICTED)
        wf.puts(content.gsub(/\R/, ''))
      end
    end
  end
end

desc 'Merge filename and url'
task :merge_filename do
  require 'rubygems'
  require 'english'
  require 'yaml'
  require 'date'
  File.open('tmp/filenamelist.txt', 'w') do |wf|
    Dir.glob("#{posts_dir}*.*").each do |file|
      File.open(file) do |f|
        content = f.read
        if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
          content = $POSTMATCH
          data = YAML.safe_load(Regexp.last_match(1))
          next unless data['published']
          date = Date.strptime(data['date'].to_s, '%Y-%m-%d')
          url = ''
          if File.basename(f, '.*').split('.').size > 1
            url = 'https://www.meganii.com/en/blog/' + date.to_s.tr('-', '/') + '/' + data['slug'] + '/'
          else
            url = 'https://www.meganii.com/blog/' + date.to_s.tr('-', '/') + '/' + data['slug'] + '/'
          end
          wf.puts(File.basename(f, '.*') + "\t" + url + "\t\"" + data['title'] + '"')
        end
      end
    end
  end
end

desc 'Create related posts mapping'
task create_relatedposts: %i[merge_contents merge_filename] do
  puts `python script/vectorize_text.py`
end

def get_stdin(message)
  print message
  STDIN.gets.chomp
end

desc 'extract amazon asin'
task :extract_amazon_asin do
  require 'rubygems'
  require 'english'
  File.open('tmp/amazon.txt', 'w') do |wf|
    Dir.glob("#{posts_dir}*.*").each do |file|
      File.open(file) do |f|
        content = f.read
        if content =~ /\{\{%.*amazon (.*)%\}\}/m
          # c = $POSTMATCH
          puts Regexp.last_match(1)
          wf.puts(Regexp.last_match(1))
        end
      end
    end
  end
end
