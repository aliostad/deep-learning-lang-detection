class CreateLearnToolCates < ActiveRecord::Migration
  def self.up
    create_table :learn_tool_cates do |t|
      t.string :title
      t.text :description

      t.timestamps
    end

    [
      ["Create & Manage Book", "Description of Create & Manage Book"],
      ["Shared Collaborative ", "Description of Shared Collaborative "],
      ["Creativity & Cool Stuffs", "Description of Creativity & Cool Stuffs"],
      ["All things Science", "Description of All things Science"],
      ["Virtual Learning ", "Description of Virtual Learning "],
      ["Math Stuff", "Description of Math Stuff"],
      ["Create & Manage Survey", "Description of Create & Manage Survey"],
      ["Create & Manage Homework", "Description of Create & Manage Homework"],
      ["Create & Manage Report", "Description of Create & Manage Report"],
      ["Learning & Time Management", "Description of Learning & Time Management"],
      ["Create & Manage Event", "Description of Create & Manage Event"],
      ["Test & Exam Preparation", "Description of Test & Exam Preparation"],
      ["Friends Connection", "Description of Friends Connection"],
    ].each do |s|
      LearnToolCate.new(:title => s[0], :description => s[1]).save
    end    
    
  end

  def self.down
    drop_table :learn_tool_cates
  end
end
