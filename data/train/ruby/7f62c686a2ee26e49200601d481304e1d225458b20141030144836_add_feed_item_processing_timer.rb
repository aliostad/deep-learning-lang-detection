# Adding things to determine how long things remain in a worker process.
class AddFeedItemProcessingTimer < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :process_start, :datetime
    add_column :feed_items, :process_end, :datetime
    add_column :feeds, :process_start, :datetime
    add_column :feeds, :process_end, :datetime
  end

  def self.down
    remove_column :feed_items, :process_start
    remove_column :feed_items, :process_end
    remove_column :feeds, :process_start
    remove_column :feeds, :process_end
  end
end

