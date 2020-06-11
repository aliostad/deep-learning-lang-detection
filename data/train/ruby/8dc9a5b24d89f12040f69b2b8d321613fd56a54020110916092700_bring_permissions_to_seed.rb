class BringPermissionsToSeed < ActiveRecord::Migration
  def self.up
    Permission.create([
                        { :title => "admin",
                          :description => "Enable Everything" },

                        { :title => "manage_user_info",
                          :description => "Edit DJ Profiles & Shows" },

                        { :title => "manage_users_full",
                          :description => "Add/Edit/Comment on Users. Manage Training steps." },

                        { :title => "manage_shows",
                          :description => "Add/Edit Shows" },

                        { :title => "manage_problem_reports",
                          :description => "Edit/Close/Open Problem Reports" },

                        { :title => "train_users",
                          :description => "Manage individual training progress and comment on users" },

                        { :title => "manage_training_steps",
                          :description => "Add/Edit/Remove Training Steps" },

                        { :title => "manage_news_posts",
                          :description => "Add/Edit News Posts on the Front End" },

                        { :title => "manage_forums",
                          :description => "Add/Edit/Delete Forums, Topics, and Messages (Replies). Post Sticky/Global/Locked topics." },

                        { :title => "manage_strikes",
                          :description => "Add/Edit Strikes. Comment on Users." },

                        { :title => "manage_schedule",
                          :description => "Add/Edit All Schedule Events" },

                        { :title => "edit_static_content",
                          :description => "Edit existing static content." }
                      ])
  end

  def self.down
  end
end
