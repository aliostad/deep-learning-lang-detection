if ProcessType.include_value?(ARGV[0])
  process_entities = ProcessEntity.joins(:process_template).where("process_templates.type = ?",ARGV[0])
  #puts process_entities.to_json
  if process_entities.count == 0
    puts "================"
    puts "Routing未找到"
    puts "================"
  else
    count = process_entities.count
    ProcessEntity.transaction do
      begin
        process_entities.each{|pe|
          pe.destroy
        }
        puts "删除#{count}个Routing!"
      rescue => e
        puts e.message
      end
    end
  end
else
  puts "类型错误!".red
end