require 'spec_helper'

describe ApiMethodsController ,:type=>"controller" do
	
		before(:each) do
			controller.stub!(:authenticate_user!).and_return(true)
			@api_method = FactoryGirl.create(:api_method)
			@parameter = FactoryGirl.create(:parameter)
		end
		
		def api_list_param
			{
				:api_list =>
				{
					 :parameter1 => 
					 {
					 :name1 => "parameter1",
					 :description1 => "description1"
					 }
				}
			}
		end
		
		def valid_attributes_api_list
			{
			:name =>  "Api_List_Name" ,
			:description => "description1",
			:position => 1
			}
		end
		
		def parameter_param
			{
			:name =>  "Parameter1" ,
			:description => "description1" ,
			:validation => "",
			:is_request => true ,
			:position => 1 ,
			:api_method_id => 1
			}
		end
		
		def valid_attributes_api_method
			{
			:name =>  "Api_Method_Name" ,
			:description  => "Api_Method_Description" ,
			:resource_url => "http://sample.com" ,
			:verb => "Api_Method_Verb" ,
			:request_url => "http://sample.com" ,
			:success_response => 'success' ,
			:error_response => '' ,
			:position => 1,
			:request_body => "{sample : {sample1}}" ,
			:notes => "notes1"
			}
		end
				
	describe "GET index" do
		it "find all the api methods" do
			get :index 
			@api_methods = ApiMethod.all
		end
	end

	describe "GET 	Show" do
		it "find a prticular api methods" do
			get :show , :id => @api_method.id
      @api_method = ApiMethod.find_by_id(@api_method.id)
		end
	end
	
	describe "GET 	New" do
		it "to create a new api method" do
			get :new 
			@api_method = ApiMethod.new
		end
	end

	describe "GET 	Edit" do
		it "to edit a new api method" do
			get :edit , :id => @api_method.id
			    @api_method = ApiMethod.find_by_id(@api_method.id)
		end
	end
 
 
	describe "POST 	Create" do
		it "to create a new api method" do
		@api_list = FactoryGirl.create(:api_list)
		@api_method = ApiMethod.new(valid_attributes_api_method)
		if @api_method.save
        @api_method.update_attributes(:api_list_id => @api_list.id)
        if api_list_param
          api_list_param.each_with_index do |f, i|
            @parameter = Parameter.new
            @parameter.api_method_id = @api_method.id
            @parameter.name = "name1"
            @parameter.description = "description"
            @parameter.validation = "validation"
            @error = ""
            @parameter.is_request = true
            @parameter.save
          end
        end
		post :create , :id => @api_list.id
		end
	end
end

	describe "PUT 	UPDATE" do
		it "to update a particular api method" do
     put :update ,:id => @api_method.id
    @api_method = ApiMethod.find_by_id(@api_method.id)
      if @api_method.update_attributes(valid_attributes_api_method)
        if parameter_param
          parameter_param.each_with_index do |f, i|
            @parameter = Parameter.find_by_id(@parameter.id)
            @parameter.update_attributes(parameter_param)
          end
        end
        if api_list_param
          api_list_param.each_with_index do |f,i|
            @parameter = Parameter.new
            @parameter.api_method_id = @api_method.id
            @parameter.name = "name1"
            @parameter.description = "description1"
            @parameter.validation = "validation1"
            @error = ""
            @parameter.is_request = true
            @parameter.save
          end
        end
      else
      end
		end
	end
	
				
	describe "DELETE destroy" do
		it "delete a particular api_method" do
			delete :destroy , :id => @api_method.id
				@api_method = ApiMethod.find_by_id(@api_method.id)
				@api_method.destroy
		end
	end

end