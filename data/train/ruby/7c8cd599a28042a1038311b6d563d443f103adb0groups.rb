# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:name) { |n| "Random name #{n}" }

  factory :group do
    name
    guest false
  end

  factory :group_for_admin, parent: :group do
    manage_users 'true'
    manage_inventory_categories 'true'
    manage_inventory_items 'true'
    manage_groups 'true'
    manage_reports_categories 'true'
    manage_reports 'true'
    manage_flows 'true'
    manage_inventory_formulas 'true'
  end

  factory :guest_group, parent: :group do
    guest true
  end
end
