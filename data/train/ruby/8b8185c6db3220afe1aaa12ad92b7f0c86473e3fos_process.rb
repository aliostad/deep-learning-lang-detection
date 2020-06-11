class OsProcess < ActiveRecord::Base
  include AuthorizationHelper

  belongs_to :fingerprint #, :counter_cache => :os_process_count
  has_many :process_files, :before_add => :decrement_src_process_file_counter_cache, :after_add => :increment_dst_process_file_counter_cache, :after_remove => :decrement_process_file_counter_cache
  has_many :process_registries, :before_add => :decrement_src_process_registry_counter_cache, :after_add => :increment_dst_process_registry_counter_cache, :after_remove => :decrement_process_registry_counter_cache

  validates_presence_of :name, :pid
  validates_associated :process_files, :process_registries
  validates_length_of :name, :maximum => 8192 
  validates_length_of :parent_name, :allow_nil => true, :allow_blank => true, :maximum => 8192
  validates_numericality_of :pid, :greater_than_or_equal_to => 0
  validates_numericality_of :parent_pid, :allow_nil => true, :allow_blank => true, :greater_than_or_equal_to => 0
  validates_numericality_of :process_file_count, :greater_than_or_equal_to => 0
  validates_numericality_of :process_registry_count, :greater_than_or_equal_to => 0

  version 5
  index :fingerprint_id,        :limit => 500, :buffer => 0
  index [:fingerprint_id, :id], :limit => 500, :buffer => 0

  after_create :update_process_file_counter_cache, :update_process_registry_counter_cache

  def to_label
    "#{name}"
  end

  private

  # XXX: These methods are probably inefficient, but its not clear how the
  # counter cache can be manipulated in any other way.

  # Before self.process_files is added, then make sure the source process_file.os_process.process_file_count
  # gets updated.
  def decrement_src_process_file_counter_cache(process_file = nil)
    if (!process_file.nil? && !process_file.os_process.nil?)
      OsProcess.decrement_counter(:process_file_count, process_file.os_process.id)
    end
  end

  # After self.process_files is added, then update self.process_file_count
  def increment_dst_process_file_counter_cache(process_file = nil)
    if not self.new_record?
      OsProcess.increment_counter(:process_file_count, self.id)
    end
  end

  # After self.process_files is subtracted, then update self.process_file_count
  def decrement_process_file_counter_cache(process_file = nil)
    if not self.new_record?
      OsProcess.decrement_counter(:process_file_count, self.id)
    end
  end

  # After self is created, then update self.process_file_count
  def update_process_file_counter_cache
    self.process_file_count.upto(self.process_files.size - 1) do
      OsProcess.increment_counter(:process_file_count, self.id)
    end
  end

  # Before self.process_registries is added, then make sure the source process_registry.os_process.process_registry_count
  # gets updated.
  def decrement_src_process_registry_counter_cache(process_registry = nil)
    if (!process_registry.nil? && !process_registry.os_process.nil?)
      OsProcess.decrement_counter(:process_registry_count, process_registry.os_process.id)
    end
  end

  # After self.process_registries is added, then update self.process_registry_count
  def increment_dst_process_registry_counter_cache(process_registry = nil)
    if not self.new_record?
      OsProcess.increment_counter(:process_registry_count, self.id)
    end
  end

  # After self.process_registries is subtracted, then update self.process_registry_count
  def decrement_process_registry_counter_cache(process_registry = nil)
    if not self.new_record?
      OsProcess.decrement_counter(:process_registry_count, self.id)
    end
  end

  # After self is created, then update self.process_registry_count
  def update_process_registry_counter_cache
    self.process_registry_count.upto(self.process_registries.size - 1) do
      OsProcess.increment_counter(:process_registry_count, self.id)
    end
  end
end
