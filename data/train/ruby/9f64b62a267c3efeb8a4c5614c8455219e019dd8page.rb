class Page
  def initialize(username)
    page = page username
    chunk = chunk(page)
    if chunk != nil
      @streak = get_streak(chunk)
    else
      @streak = "error"
    end
  end

  def streak
    @streak
  end

  private

  def page(username)
    begin
      open("https://github.com/#{username}").read
    rescue
      "error"
    end
  end

  def chunk(page)
    location = page.index '<span class="text-muted">Longest streak'
    if location != nil
      page[location..location+100]
    end
  end

  def get_streak(chunk)
    location = chunk.index 'day'
    string_to_match = chunk[location-5..location-2]
    regex = /\d+/
    regex.match(string_to_match).to_s
  end
end
