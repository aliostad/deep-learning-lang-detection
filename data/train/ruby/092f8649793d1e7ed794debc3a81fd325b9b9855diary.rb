module Woli
  class Diary
    attr_reader :repository

    def initialize(repository)
      @repository = repository
    end

    def all_entries_dates
      @repository.all_entries_dates
    end

    def entry(date)
      @repository.load_entry(date)
    end

    def load_or_create_entry(date)
      entry = @repository.load_entry(date)
      return entry if entry

      DiaryEntry.new(date, '', @repository)
    end

    def missing_entries_count
      last_entry_date = @repository.all_entries_dates.last
      return 0 unless last_entry_date
      Integer(Date.today - last_entry_date)
    end
  end
end
