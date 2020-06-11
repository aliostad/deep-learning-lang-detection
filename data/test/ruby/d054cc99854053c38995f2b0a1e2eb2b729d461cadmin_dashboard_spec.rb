require 'rails_helper'

RSpec.describe "Admin dashboard" do
  let(:admin) { create(:admin) }

  before(:each) do
    login_as(admin)
  end

  it "is directed to admin dashboard when admin logs in" do
    expect(current_path).to eq(admin_path)
    expect(page).to have_content("Admin")
    expect(page).to have_content("Successfully logged in as #{admin.username}")
  end

  it "has a link to Manage Items" do
    create(:item)

    expect(page).to have_link("Manage Items")

    click_link_or_button("Manage Items")

    expect(current_path).to eq(admin_items_path)

    expect(page).to have_link("Cheese Toast")
  end

  it "has a link to Manage Categories" do
    create(:category)

    expect(page).to have_link("Manage Categories")

    click_link_or_button("Manage Categories")

    expect(current_path).to eq(admin_categories_path)

    expect(page).to have_link("Entree")
  end

  it "has a link to Manage Orders" do
    create(:order)

    expect(page).to have_link("Manage Orders")

    click_link_or_button("Manage Orders")

    expect(current_path).to eq(admin_orders_path)
  end

end
