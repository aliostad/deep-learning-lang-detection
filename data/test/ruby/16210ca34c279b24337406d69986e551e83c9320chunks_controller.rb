class Admin::ChunksController < ApplicationController
  layout 'standard'
  
  
  def input
    @chunk = Chunk.new
    @chunk.filename = params[:chunk][:filename]
  end
  
  
  def cleanup
    cleaner = Chunk.new
    cleaner.clean_up_database
    flash.now[:notice] ="Database cleaned!"
    redirect_to(:action => :list_links)

  end
  
  def remove_stale_files
    filelist = Uploadedfile.filelist
    @deleted = Array.new
    filelist.map {|f|
      chunk = Chunk.all(:conditions => ['filename = ? and expire_date >= ?', f, DateTime.now.to_date] )
      if chunk.empty? 
        puts "\n Will delete: " + File.join(RAILS_ROOT, UPLOAD_DIR, f).to_s
        @deleted.push(f)
        File.delete(File.join(RAILS_ROOT, UPLOAD_DIR, f))
      end
    }
    
    flash.now[:notice] = "there are no unused files" if @deleted.empty?
    
    flash.now[:header] = "removed the following files" unless @deleted.empty?
    
  end
  
  def create
    @chunk = Chunk.new(params[:chunk])
    if !@chunk.valid?
      render(:action => :input)
    else
      @chunk.set_link
      @chunk.save!
      flash.now[:message] = "your upload was successfully created"
      email = ChunkMailer.deliver_send_link(@chunk)
      if params[:notify_client]
        email = ChunkMailer.deliver_notify_client(@chunk)
      end
      render(:action => :show_link)
      
    end
  end
  
  def list_links
    puts "Base URL: #{BASE_URL}"
    flash.now[:header] = "list of all available links"
    @chunks = Chunk.paginate :page => params[:page], :conditions => ['expire_date >= ? and (download_count < download_count_max or download_count_max IS NULL)', DateTime.now.to_date], :per_page => 5
    
  end
  
  def list_expired_links
    flash.now[:header] = "list of all expired links"
    @chunks = Chunk.paginate :page => params[:page], :conditions => ['expire_date < ? or download_count >= download_count_max', DateTime.now.to_date], :per_page => 5
  end
end
