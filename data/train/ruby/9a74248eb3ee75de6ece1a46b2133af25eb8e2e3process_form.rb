class ProcessForm
  include ActiveModel::Model
  attr_accessor :processes, :process_list_array

  def self.save(processes_array, process_list_array)
  	
      processes_temp = processes_array.split(",")
      processes = []
      processes_temp.each do |p|
      	processes << p.split("/")
      end
      
      processes_list_temp = process_list_array.split(",")
      process_list = []
      processes_list_temp.each do |p|
      	process_list << p.split("/")
      end
      
      processes.each do |p|
        if p[1]
        	process = AllProcess.find(p[1])
        	if process.title != p[0]
        		 process.title = p[0]
        		 process.save!
        	end
        else
        	AllProcess.create(:title=>p[0])
        end
      end
      
      ProcessList.destroy_all
      process_list.each do |p|
        ProcessList.create(:process_type_id=>ProcessType.where(:title=>p[0]).first.id, :all_process_id=>p[1])
      end
  end

end
