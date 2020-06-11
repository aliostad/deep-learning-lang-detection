class Enrollment < BasePage

  expected_element :home_link

  wrapper_elements
  frame_element

  element(:home_link) { |b| b.frm.link(text: "Home") }

  action(:search_for_calendar_or_term) { |p| p.frm.link(text: "Search for Calendar or Term").click }
  action(:create_academic_calendar) { |p| p.frm.link(text: "Create New Calendar (Academic Year)").click }
  action(:create_holiday_calendar) { |p| p.frm.link(text: "Create Holiday Calendar").click }
  action(:perform_rollover) { |p| p.frm.link(text: "Perform Rollover").click }
  action(:manage_populations) { |p| p.frm.link(text: "Manage Populations").click }
  action(:view_rollover_details) { |p| p.frm.link(text: "View Rollover Details").click }
  action(:create_course_offerings) { |p| p.frm.link(text: "Create Course Offerings").click }
  action(:manage_course_offerings) { |p| p.frm.link(text: "Manage Course Offerings").click }
  action(:manage_soc) { |p| p.frm.link(text: "Manage SOC").click }
  action(:schedule_of_classes) { |p| p.frm.link(text: "Schedule of Classes").click }
  action(:manage_registration_windows) { |p| p.frm.link(text: "Manage Registration Windows and Appointments").click }
  action(:add_hold) { |b| b.frm.link(text: "Add Hold").click }
  action(:manage_hold) { |b| b.frm.link(text: "Manage Hold").click }

end