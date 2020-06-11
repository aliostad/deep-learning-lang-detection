def sigar_manage()
  manage_width = 880
  manage_height = 680
  c = Sketchup.active_model.active_view.center
  dlgManage = UI::WebDialog.new("Show Sketchup.com", true, "ShowSketchUpDotCom", manage_width, manage_height, c[0]-manage_width/2, c[1]-manage_height/2, true);
  dlgManage.set_file File.dirname(__FILE__) + "/html/manage.html"
  
  # Add callback to test the connection to the Database
  dlgManage.add_action_callback("sigar_export_testConnection") {|dialog, params|
     UI.messagebox("You called sigar_export_testConnection with: " + params.to_s)
   }
  # Add callback to refresh the models of the manage page
  dlgManage.add_action_callback("sigar_model_refresh") {|dialog, params|
    UI.messagebox("You called sigar_refresh with: " + params.to_s)
   }
  # Add callback to close the dialog
  dlgManage.add_action_callback("sigar_export_close") {|dialog, params|
    dlgManage.close
   }
  # Show the window
  dlgManage.show
end