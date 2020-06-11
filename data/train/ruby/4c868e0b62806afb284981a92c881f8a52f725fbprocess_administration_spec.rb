feature "Process management" do
  let(:process_index) { ProcessIndex.new(Capybara) }
  let(:process_detail) { ProcessDetail.new(Capybara) }

  scenario "Admin views process index" do
    process1 = Bumbleworks.launch!('task_process', :entity => Widget.new(41))
    process2 = Bumbleworks.launch!('task_process')
    wait_until { process1.tasks.count == 2 && process2.tasks.count == 2 }

    visit_scoped '/processes/page/1'

    expect(process_index).to have_processes([process1, process2])
  end

  scenario "Admin views process detail" do
    process = Bumbleworks.launch!('task_process', :entity => Widget.new(56))
    wait_until { process.tasks.count == 2 }

    visit_scoped "/processes/#{process.id}"

    expect(process_detail).to have_process(process)
    expect(process_detail).to have_entity(Widget.new(56))
  end
end