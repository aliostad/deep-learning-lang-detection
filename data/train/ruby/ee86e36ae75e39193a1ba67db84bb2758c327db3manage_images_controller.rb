class Images::ManageImagesController < ApplicationController
	autocomplete :manage_image, :subject
	 def index    
		@manage_images = ManageImage.paginate :page => params[:page], :order => 'created_at DESC'	  
	     respond_to do |format|
	      format.html 
	      format.xml  { render :xml => @manage_images }
	    end
       end
    
      def new
       @manage_image = ManageImage.new
         respond_to do |format|
           format.js
          format.html # new.html.erb 
        end
	end

  def create  
    @manage_image = ManageImage.new(params[:manage_image])    
    authorize! :create, ManageImage      
    @manage_image.author_id = current_user.id
    respond_to do |format|
      if @manage_image.save
         format.html { redirect_to(manage_images_path, :notice => 'Image has been successfully uploaded.') }
         format.xml  { render :xml => @manage_image, :status => :created, :location => @upload_image }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @manage_image.errors, :status => :unprocessable_entity }
      end
    end
    
  end

	def edit 
		@manage_image = ManageImage.find(params[:id])
		respond_to do |format|
		   format.js
		  format.html # new.html.erb 
		end
	end
  
    def update    
    @manage_image = ManageImage.find(params[:id])
    
    authorize! :update, @manage_image
    
    respond_to do |format|
      if @manage_image.update_attributes(params[:manage_image].merge :author => current_user)
	 format.html { redirect_to(manage_images_path, :notice => 'Image has been successfully updated.') }
         format.xml  { render :xml => @manage_image, :status => :created, :location => @manage_image }
      else   
        format.html { render :action => "edit" }
        format.xml  { render :xml => @manage_image.errors, :status => :unprocessable_entity }
      end
    end
  end




   def show
	@manage_image = ManageImage.find(params[:id])
         respond_to do |format|
           format.js
           format.html # new.html.erb         
        end

  end

   # DELETE /image/1
  def destroy
   authorize! :destroy, ManageImage  
    @manage_image = ManageImage.find(params[:id])     
    @manage_image.destroy    
    respond_to do |format|
      format.html { redirect_to manage_images_path, :notice => 'Image Management record was successfully deleted.' }
      format.xml  { head :ok }
    end
  end


def download_image  
  begin
   uploadimage = ManageImage.find(params[:id])      
      #~ render :text => File.exists?("#{RAILS_ROOT}/public/system/documents/#{params[:id]}/original/#{document.document_file_name}") and return
    
		  if uploadimage	  
			  data = open(uploadimage.image.url(:original)).read
			  send_data data, :filename => uploadimage.image.original_filename 		
		  else
			redirect_to manage_images_path
		 end
  	 rescue
		redirect_to manage_images_path
	 end
    end

  def view_uploadimage
	begin 
	 @uploadimage = ManageImage.find(params[:id])     
		respond_to do |format|
	      format.js 
	      format.xml  { render :xml => @uploadimage }
	    end    
	 #~ if uploadimage
		 #~ redirect_to uploadimage.image.url
	 #~ end
	 rescue
		redirect_to manage_images_path
	 end
 end

    def tag_search_logic(str)
	     return [],[],[] if str.blank?
	     cond_text   = str.split.map{|w| "tags LIKE ? "}.join(" OR ")
	   
	     cond_values = str.split.map{|w| "%#{w}%"}
	     return str,cond_text,cond_values
    end


def search	
	if !params[:search].blank?
		@search_word = params[:search]
		
		str,cond_text,cond_values = tag_search_logic(params[:search])		
		tags = ManageImage.search(str,cond_text,cond_values) 
		images = []
		for tag in tags
			manage_image = ManageImage.find_by_id(tag.id)
			images << manage_image.id
	        end
		
     search_word = params[:search].downcase
    
    
	    if images.size > 0	
	        @find_images =  ManageImage.find(:all,:conditions => ["id in (#{images.join(',')}) OR LOWER(subject) LIKE ?","%#{search_word}%"]).paginate :page => params[:page],:per_page => 15  #ManageImage.tagged_with("%#{params[:search]}%") 
	    else
		@find_images =  ManageImage.find(:all,:conditions => ["LOWER(subject) LIKE ? OR LOWER(subject) LIKE ? OR LOWER(subject) LIKE ?","%#{search_word}%","#{search_word}%","%#{search_word}"]).paginate :page => params[:page],:per_page => 15  
	    end
	    
	    
	     if params[:search] == 'Enter keyword'
		     @msg = 'Please enter any tag to search'
	     end	      
		     respond_to do |format|
		      format.html
		      format.js 
		      format.xml  { render :xml => @find_images }
		    end
	end
	
end    ### method end

    
end
