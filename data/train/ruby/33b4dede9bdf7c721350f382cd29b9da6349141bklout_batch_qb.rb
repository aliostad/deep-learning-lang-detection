class KloutBatchQb < SimpleWorker::Base

  merge "../models/user"

  merge_worker File.join(File.dirname(__FILE__), "klout_batch_worker.rb"), "KloutBatchWorker"

  attr_accessor :db_settings

  def run
    log "Running Klout Batch Quarterback!"
    init_mongohq

    users = User.all
    users_chunk = []

    i=0
    users.each do |u|
      #i>=31 ? break : i+=1

      log "Adding user #{u.twitter_username}"
      users_chunk << u

      if users_chunk.size % 40 == 0
        log "Creating worker with #{users_chunk.inspect}"

        begin
          queue_kbw(users_chunk)
        rescue => ex
          log "There was a problem --> #{ex}"
        end

        users_chunk = []
      end
    end

    queue_kbw(users_chunk) unless users_chunk.empty?
  end

  def queue_kbw(users_chunk)
    kbw = KloutBatchWorker.new
    kbw.users = users_chunk
    kbw.db_settings = db_settings
    kbw.queue(:priority => 2)
  end


  def init_mongohq
    Mongoid.configure do |config|
      config.database = Mongo::Connection.new(db_settings["host"], db_settings["port"]).db(db_settings["database"])
      config.database.authenticate(db_settings["username"], db_settings["password"])
      config.persist_in_safe_mode = false
    end
  end
end