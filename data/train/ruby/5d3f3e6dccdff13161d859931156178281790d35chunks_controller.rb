class ChunksController < InheritedResources::Base
  belongs_to :source

  actions :all, :except => [ :edit, :update ]
  respond_to :html, :xml, :json

  def show
    show! do |format|
      format.wav { send_file @chunk.file, :type => :wav }
      format.ogg { send_file @chunk.file, :type => :ogg }
      format.mp3 { send_file @chunk.file, :type => :mp3 }
    end
  end

  def create
    create!

    if @chunk.valid? and @chunk.time_range == label_selection.time_range
      label_selection.clear
    end
  end

  protected

  def source
    association_chain.first
  end

  def label_selection
    user_session.label_selection
  end

  def build_resource
    if action_name == 'new'
      if label_selection.same_source?(source)
        @chunk = label_selection.chunk
      end

      @chunk ||= source.default_chunk 
    end

    super
  end

end
