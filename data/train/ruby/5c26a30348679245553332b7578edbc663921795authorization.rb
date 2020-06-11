# frozen_string_literal: true
module Users
  # module for checking authorization
  module Authorization
    include RSpec::Matchers
    include Capybara::DSL

    def has_manage_content_button?
      if ENV['tfd'] || ENV['tfdso'] || ENV['marigold']
        has_text? 'Manage Content'
      elsif ENV['sunnyside']
        has_text? 'MANAGE CONTENT'
      end
    end

    def has_arm_creation_button?
      if ENV['tfd'] || ENV['tfdso'] || ENV['marigold']
        has_css?('.btn.btn-primary', text: 'New')
      elsif ENV['sunnyside']
        has_css?('.btn.btn-primary', text: 'NEW')
      end
    end

    def has_clinician_dashboard_buttons?
      compare_buttons(clinician_buttons)
    end

    def has_researcher_dashboard_buttons?
      compare_buttons(researcher_buttons)
    end

    def has_super_user_arms_buttons?
      compare_buttons(super_user_arms_buttons)
    end

    def has_super_user_groups_buttons?
      compare_buttons(super_user_groups_buttons)
    end

    private

    def compare_buttons(buttons)
      button_names = all('.btn').map(&:text)
      button_names.count.should eq buttons.count
      button_names.should =~ buttons
    end

    def clinician_buttons
      if ENV['tfd']
        ['Arm', 'Patient Dashboard', 'Messaging']
      elsif ENV['tfdso']
        ['Arm', 'Patient Dashboard', 'Messaging', 'Group Dashboard',
         'Moderate', 'Manage Profile Questions']
      elsif ENV['marigold']
        ['Arm', 'Patient Dashboard', 'Messaging', 'Group Dashboard',
         'Moderate', 'Manage Profile Questions', 'Manage Incentives']
      elsif ENV['sunnyside']
        ['ARM', 'PATIENT DASHBOARD', 'GROUP DASHBOARD', 'MESSAGING',
         'MODERATE', 'MANAGE PROFILE QUESTIONS', 'MANAGE INCENTIVES']
      end
    end

    def researcher_buttons
      if ENV['tfd']
        ['Arm', 'Manage Tasks', 'Edit', 'Destroy']
      elsif ENV['tfdso']
        ['Arm', 'Manage Tasks', 'Edit', 'Destroy', 'Moderate',
         'Manage Profile Questions']
      elsif ENV['marigold']
        ['Arm', 'Manage Tasks', 'Edit', 'Destroy', 'Moderate',
         'Manage Profile Questions', 'Manage Incentives']
      elsif ENV['sunnyside']
        ['ARM', 'MANAGE TASKS', 'EDIT', 'DESTROY', 'MODERATE',
         'MANAGE PROFILE QUESTIONS', 'MANAGE INCENTIVES']
      end
    end

    def super_user_arms_buttons
      if ENV['tfd'] || ENV['tfdso'] || ENV['marigold']
        ['Edit', 'Manage Content', 'Destroy']
      elsif ENV['sunnyside']
        ['EDIT', 'MANAGE CONTENT', 'DESTROY']
      end
    end

    def super_user_groups_buttons
      if ENV['tfd']
        ['Arm', 'Patient Dashboard', 'Messaging', 'Manage Tasks', 'Edit',
         'Destroy']
      elsif ENV['tfdso']
        ['Arm', 'Patient Dashboard', 'Messaging', 'Manage Tasks', 'Edit',
         'Destroy', 'Group Dashboard', 'Moderate',
         'Manage Profile Questions']
      elsif ENV['marigold']
        ['Arm', 'Patient Dashboard', 'Messaging', 'Manage Tasks', 'Edit',
         'Destroy', 'Group Dashboard', 'Moderate', 'Manage Incentives',
         'Manage Profile Questions']
      elsif ENV['sunnyside']
        ['ARM', 'PATIENT DASHBOARD', 'MESSAGING', 'MANAGE TASKS', 'EDIT',
         'DESTROY', 'GROUP DASHBOARD', 'MODERATE', 'MANAGE INCENTIVES',
         'MANAGE PROFILE QUESTIONS']
      end
    end
  end
end
