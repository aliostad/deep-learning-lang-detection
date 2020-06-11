#!/usr/bin/env ruby
raise "usage: chunky.rb input_dir output_dir chunk_size_mb" unless ARGV.length==3
INPUT_DIR, OUTPUT_DIR, MAX_CHUNK_SIZE_MB = ARGV
raise "no such input dir #{INPUT_DIR}" unless File.directory? INPUT_DIR
`rm -rf #{OUTPUT_DIR} && mkdir #{OUTPUT_DIR}`
MAX_CHUNK_SIZE = MAX_CHUNK_SIZE_MB.to_i * 1024**2
chunk_id = 0
chunk_size = 0
`ls #{INPUT_DIR}`.each do |file|
	file = "#{INPUT_DIR}/" + file.chomp
	file_size = File.size file
	if chunk_size + file_size > MAX_CHUNK_SIZE
		chunk_id += 1
		chunk_size = 0
	end
	cmd = "cat \"#{file}\" >> \"#{OUTPUT_DIR}/chunk_#{sprintf("%03d",chunk_id)}.gz\""
	puts cmd
	`#{cmd}`
	chunk_size += file_size
end

