require File.dirname(__FILE__) + '/grammar'
require File.dirname(__FILE__) + '/diff_engine'
require 'rubygems'
require 'trollop'

OPTS = Trollop::options do 
    opt :grammar, "Filename of the saved grammar (from the C++ sequitur program)", :type => :string
    opt :old, "Filename of the old, already recompressed, output", :type => :string
    opt :new, "Filename of the new, already recompressed, output", :type => :string
    opt :old_modules, "YAML dump of the module list hash for the old file", :type => :string
    opt :new_modules, "YAML dump of the module list hash for the new file", :type => :string
end


engine=DiffEngine.new(
    Grammar.new(OPTS[:grammar]),
    YAML.load(File.read(OPTS[:old_modules])),
    YAML.load(File.read(OPTS[:new_modules]))
)
sdiff_output=`sdiff -d #{OPTS[:old]} #{OPTS[:new]}`.split("\n")
sd_markedup=engine.sdiff_markup( sdiff_output )
oldraw=File.read(OPTS[:old]).split("\n")
newraw=File.read(OPTS[:new]).split("\n")
raw_markedup=engine.diff_and_markup( oldraw, newraw )
puts "Checking raw tokens"
if raw_markedup==sd_markedup
    puts "OK"
else
    puts "No :("
end
puts "Checking chunk types"
if raw_markedup[0].map {|chunk| chunk.chunk_type} == sd_markedup[0].map {|chunk| chunk.chunk_type} and
   raw_markedup[1].map {|chunk| chunk.chunk_type} == sd_markedup[1].map {|chunk| chunk.chunk_type}
    puts "OK"
else
    puts "No :("
end
puts "Checking offsets"
if raw_markedup[0].map {|chunk| chunk.offset} == sd_markedup[0].map {|chunk| chunk.offset} and
   raw_markedup[1].map {|chunk| chunk.offset} == sd_markedup[1].map {|chunk| chunk.offset}
    puts "OK"
else
    puts "No :("
end
sd_markedup[0].zip(sd_markedup[1]).each {|o, n| 
    puts "#{o.chunk_type} at #{o.offset}:#{o.size}(#{o.length}) / #{n.offset}:#{n.size}(#{n.length})"
    if o.length!=n.length
        puts "wtf?"
        p o
        p n
        puts "/wtf"
    end
    if o.chunk_type==:diff
        o.zip(n).each {|pair|
            puts "%-20.20s     %-20.20s" % [engine.prettify_token(pair[0],:old),engine.prettify_token(pair[1],:new)]
        }
        next
        puts "EXPANDING"
        old_expanded=o.map {|elem| engine.expand_rule( elem,2 )}.flatten
        new_expanded=n.map {|elem| engine.expand_rule( elem,2 )}.flatten
        old_diffed,new_diffed=engine.diff_and_markup(old_expanded, new_expanded)
        old_diffed.zip( new_diffed ).each {|od,nd|
            puts "#{od.chunk_type}:#{od.size} -- #{nd.chunk_type}:#{nd.size}"
            next unless od.chunk_type==:diff
            od.zip(nd).each {|a,b| puts "%-20.20s   %-20.20s" % [engine.prettify_token(a,:old),engine.prettify_token(b,:new)]}
        }
    end
}
