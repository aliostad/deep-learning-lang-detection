class PopulatesCapability < ActiveRecord::Migration
  def self.up
    Capability.create :name => "Manage teachers"
    Capability.create :name => "Manage teachings"
    Capability.create :name => "Manage classrooms"
    Capability.create :name => "Manage buildings"
    Capability.create :name => "Manage timetables"
  end

  def self.down
    ids = []
    ids << (Capability.find_by_name "Manage timetables").id
    ids << (Capability.find_by_name "Manage buildings").id
    ids << (Capability.find_by_name "Manage classrooms").id
    ids << (Capability.find_by_name "Manage teachings").id
    ids << (Capability.find_by_name "Manage teachers").id
    Capability.destroy(ids)
  end
end
