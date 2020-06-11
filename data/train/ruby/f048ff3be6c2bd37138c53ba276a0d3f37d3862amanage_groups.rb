require 'watir/test'
require 'Users/user_variables'
require 'Utility/profile_common'
require 'Utility/common_methods'

class TestManageGroups < UserVariables

  include Common_Methods
  include Profile_Common
  include Manage_Groups

  def setup
    #Access join page
    super
    $browser.goto($patch_login)
  end

####################
##Smoke Test File!##
#################### 

##########
##Tests!##
##########

#Test 25851: Verify expected UI of the Manage Group
  def test_ID_25851_ui_of_the_manage_group_01
    login_as_user1
    go_to_edit_profile_page
    verify_elements_left_nav "test_ID_25851_ui_of_the_manage_group"
    $profile_manage_groups.when_present(60).click
    sleep 5
    verify_text "test_ID_25851_ui_of_the_manage_group", "Manage Groups", "Email Settings", "Following", "Followers", "Posts"
    verify_elements_on_manage_groups_page "test_ID_25851_ui_of_the_manage_group"
  end

#Test 25851: Verify group_icon_redirect
  def test_ID_25851_ui_of_the_manage_group_02
    login_as_user1
    go_to_edit_profile_page
    $profile_manage_groups.when_present(60).click
    sleep 5
    group_icon_redirect
  end

#Test 25851: click_group_name_verify_redirect
  def test_ID_25851_ui_of_the_manage_group_03
    login_as_user1
    go_to_edit_profile_page
    $profile_manage_groups.when_present(60).click
    sleep 5
    click_group_name_verify_redirect "editors-picks"
  end

#Test 25851: Verify email_settings_redirect
  def test_ID_25851_ui_of_the_manage_group_04
    login_as_user1
    go_to_edit_profile_page
    $profile_manage_groups.when_present(60).click
    sleep 5
    email_settings_redirect
  end

#Test 25851: following_button_to_unfollow_and_follow
  def test_ID_25851_ui_of_the_manage_group_05
    login_as_user1
    go_to_edit_profile_page
    $profile_manage_groups.when_present(60).click
    sleep 5
    following_button_to_unfollow_and_follow
    #verify_the_links_on_the_side_bar_of_manage_groups "test_ID_25851_ui_of_the_manage_group"
  end

#Test 25851: Verify expected UI of the Manage Group
  def atest_ID_25851_ui_of_the_manage_group_06
    login_as_user1
    go_to_edit_profile_page
    $profile_manage_groups.when_present(60).click
    sleep 5
    verify_the_links_on_the_side_bar_of_manage_groups "test_ID_25851_ui_of_the_manage_group"
  end

end  # end of class