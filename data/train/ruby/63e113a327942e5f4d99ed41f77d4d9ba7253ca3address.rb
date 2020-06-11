class Address
  attr_accessor :street, :city, :state, :zip

  def initialize(hash)
    return if !hash.respond_to? :fetch

    @street = hash.fetch 'street', nil
    @city   = hash.fetch 'city',   nil
    @state  = hash.fetch 'state',  nil
    @zip    = hash.fetch 'zip',    nil
  end

  def first_line()
    @street
  end

  def second_line()
    chunk = [@city, @state].compact() * ", "
    chunk += " #{@zip}" unless @zip.nil?
    return chunk
  end

  def to_s()
    chunk = [@street, @city, @state].compact() * ", "
    chunk += " #{@zip}" unless @zip.nil?
    return chunk
  end
end
