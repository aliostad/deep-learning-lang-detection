#!/usr/bin/ruby

schemes = ['dot', 'proxy', 'proxy-mhear']
#chunk_sizes = ['8K', '16K', '32K']
chunk_sizes = ['8K']

def sys(cmd)
  if not system(cmd)
    raise "command failed: #{cmd}"
  end
end

if ARGV.size < 1
    puts "Usage: ./generate_xput_improvement_cdf_data.rb <results_dir - the directory which has \"results\">"
    puts "Precondition - should have run analyze_xput.rb"
    exit
end

RESULTS_DIR = ARGV[0]
puts "#{RESULTS_DIR}"
results_base_dir = "#{RESULTS_DIR}/results/xput"
puts "#{results_base_dir}"

for chunk_size in chunk_sizes

    puts "##################################################"
    puts "chunk size = #{chunk_size}"

    for scheme in schemes
        puts "-----"
        puts "chunk size = #{chunk_size}"
        sys("./cdfgen #{results_base_dir}/#{chunk_size}/#{scheme}/xput_individual.dat 10 1 #{results_base_dir}/xput_#{chunk_size}_#{scheme}.cdf")
    end
end

sys("./graph_xput_improvement_fixed_chunk_size.rb #{RESULTS_DIR}")
