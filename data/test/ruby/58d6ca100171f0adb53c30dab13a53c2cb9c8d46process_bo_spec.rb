require 'spec_helper'

module Guara
  
  module Jobs
    
    module ActiveProcess

      describe ProcessBusinessObject do
      
        before do
        
          ### Creating process test
          process = CustomProcess.create(name: "Process Test")
        
          level = -1
        
          steps = Array.new(5) do
             level+=1
             Step.create(name: "Process Test", custom_process: process, level: level)
          end
        
          last = nil
          steps.reverse.each do |s|
            s.next = last.id unless last.nil?
            last = s
          
            position = 0
            1..5.times do
              s.attrs.build(type_field: "text",
                            title: Faker::Name.first_name,
                            column: 1,
                            position: position)
            end
          
            s.save
          
            #creating bo
          
          end
        
          process.steps = steps
        
          #process instance
          @bo = ProcessBusinessObject.new
        end
      
        subject (@bo)
      
        
        
      
      end
    end
  end
end