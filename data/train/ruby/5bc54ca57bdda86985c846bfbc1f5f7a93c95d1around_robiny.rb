#!/usr/bin/env ruby
raise "usage: round_robiny.rb input_dir output_dir num_files_per_chunk" unless ARGV.length==3
INPUT_DIR, OUTPUT_DIR, FILES_PER_CHUNK = ARGV
raise "no such input dir #{INPUT_DIR}" unless File.directory? INPUT_DIR
raise "output dir #{OUTPUT_DIR} already exists!" if File.directory? OUTPUT_DIR
`mkdir #{OUTPUT_DIR}`
chunk_id=0
`ls #{INPUT_DIR}`.each do |file|
	file = "#{INPUT_DIR}/" + file.chomp
	file_size = File.size file
	cmd = "cat \"#{file}\" >> \"#{OUTPUT_DIR}/chunk_#{sprintf("%03d",chunk_id)}.gz\""
	puts cmd
	`#{cmd}`
	chunk_id = (chunk_id+1) % FILES_PER_CHUNK.to_i
end

