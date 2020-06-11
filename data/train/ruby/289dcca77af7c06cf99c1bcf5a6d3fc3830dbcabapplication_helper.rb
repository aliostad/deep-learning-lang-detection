module ApplicationHelper

  def divide_in_chunks(arr, chunk_size)
    chunks = {}
    chunk_idx = 0
    arr.each_with_index do |item,idx|
      chunks[chunk_idx] ||= []
      chunks[chunk_idx] << item
      if (idx+1)%chunk_size == 0
        chunk_idx=chunk_idx+1
      end
    end
    chunks
  end

  def gravatar_url(user)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.downcase)}?s=40"
  end

  def select_collection_rating_values
    Review.rating_range.to_a.reverse.map do |rating|
      [ pluralize(rating, 'star'), rating]
    end
  end

  def select_collection_category_values
    Category.all.map do |category|
      [ category.name, category.id ]
    end
  end

  def select_rating_values
    (0.0..5.0).step(0.1).map(&Proc.new{ |v| v.round(2).to_f })
  end
end
