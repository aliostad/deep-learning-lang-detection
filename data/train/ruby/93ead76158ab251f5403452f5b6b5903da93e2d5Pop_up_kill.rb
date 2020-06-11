    require 'win32/process'
	
	
    def callPopupKillerFF
        $pid = Process.create(:app_name => 'ruby click_popup_FF.rb', :creation_flags => Process::DETACHED_PROCESS).process_id
		#puts "POPUP KILLER FF ACTIVATED!"
    end

    def callPopupKillerIE
        $pid = Process.create(:app_name => 'ruby click_popup_IE.rb', :creation_flags => Process::DETACHED_PROCESS).process_id
		#puts "POPUP KILLER IE ACTIVATED!"
    end

    def killPopupKiller
        Process.kill(9,$pid)
		#puts "POPUP KILLER KILLED!"
    end 