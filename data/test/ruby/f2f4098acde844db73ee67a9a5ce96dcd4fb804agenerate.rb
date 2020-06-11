require 'open-uri'
require 'json'

root = JSON::parse(open("https://api.github.com/repos/jquery/api.jquery.com/git/trees/master").read, symbolize_names: true)
sha = root[:tree].find{|x| x[:path] == 'entries'}[:sha]

api_lists = JSON::parse(open("https://api.github.com/repos/jquery/api.jquery.com/git/trees/#{sha}").read, symbolize_names: true)
s = ""
api_lists[:tree].map do |api|
  a = api[:path][/([^.]+)\.xml$/, 1]
  a.sub(/-.+$/, '')
end.select do |api|
  api.size > 2
end.sort.uniq.each do |api|
  s = s + api + "\n"
end

open('./dict/jquery.dict', 'w'){|f| f.write(s)}
