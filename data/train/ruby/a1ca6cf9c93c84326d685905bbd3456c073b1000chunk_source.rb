class ChunkSource
  def initialize(config, instances)
    @config = config
    @instances = instances
  end

  # what is :first, :all, :chunk
  # options are:
  #   :chunk_size - how big the chunks are
  #   :chunk_key  - unique name of the context for looping over all instances in chunks. every time calling this method with same key will return next chunk
  #   :from       - nil to pick default scope for role_name, otherwise :zone or :region
  def select(what, role_name, zone, options = {})
    # :zone or :region
    from_zone = (options[:from] || @config.combined[role_name].scope).to_sym == :zone

    source_instances = from_zone ? @instances.with_zone(zone) : @instances
    source_instances = source_instances.with_role(role_name)

    what = :all if what == :chunk && options[:chunk_size].nil?

    case what
    when :all : source_instances
    when :first : source_instances.first
    when :chunk : pick_next_chunk(source_instances, options[:chunk_size], options[:chunk_key])
    end
  end

  def pick_next_chunk(all, size = 1, key = "")
    # this is the starting index of the current chunk
    # this index doesn't wrap around, it needs to be wrapped by the lookup methiod
    @chunk_indexes ||= {}
    @chunk_indexes[key] ||= 0

    index = @chunk_indexes[key] % all.count # real index
    @chunk_indexes[key] += size # update for next time this is called

    # so we don't have to do any math to wrap it
    big_all = all * size
    big_all[index,size]
  end
end