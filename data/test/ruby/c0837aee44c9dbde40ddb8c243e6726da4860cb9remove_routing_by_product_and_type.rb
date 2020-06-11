product = Part.where(nr:ARGV[0],type:PartType::PRODUCT).first
if product.nil?
  puts "成品未找到".red
else
  process_entities = ProcessEntity.joins(:process_template).where("process_entities.product_id = ? AND process_templates.type = ?",product.id,ARGV[1])

  if process_entities.count == 0
    puts "================"
    puts "Routing未找到"
    puts "================"
  else
    ProcessEntity.transaction do
      begin
        process_entities.each{|pe|
          pe.destroy
        }
        puts "删除#{process_entities.count}个Routing!"
      rescue => e
        puts e.message
      end
    end
  end
end