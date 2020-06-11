class ReportDecorator < RecordDecorator

  def is_chunky?
    available_chunk_sizes.present?
  end

  def chunks
    available_chunk_sizes + ['all']
  end

  def chunky_link(chunk)
    h.link_to chunk == 'all' ? h.t('.all') : chunk, { report: report_params.merge(limit: chunk) }, class: active_or_not(chunk)
  end

    private

  def active_or_not(chunk)
    if current_chunk
      current_chunk == chunk.to_s ? 'active' : 'false'
    elsif chunk == first_chunk
      'active'
    else
      'false'
    end
  end

  def report_params
    h.params[:report] || {}
  end

  def first_chunk
    available_chunk_sizes.first
  end

  def available_chunk_sizes
    chunk_sizes.select { |n| n < total_number_of_records }
  end

  def current_chunk
    report_params.try(:[], :limit)
  end
end
