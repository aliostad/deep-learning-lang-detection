require_relative "../../../spec_helper.rb"

describe Chunks::Admin::SharedChunksController do    
  it "lists all shared chunks, ordered by name" do
    shared_a = FactoryGirl.create(:shared_chunk, name: "A")
    shared_c = FactoryGirl.create(:shared_chunk, name: "C")
    shared_b = FactoryGirl.create(:shared_chunk, name: "B")
    get :index, use_route: "chunks"
    assigns(:shared_chunks).should == [shared_a, shared_b, shared_c]
  end
  
  describe "editing a shared chunk" do
    before(:each) do
      @shared = FactoryGirl.create(:shared_chunk)
    end
    
    it "updates successfully" do
      put :update, use_route: "chunks", id: @shared, shared_chunk: {name: "A New Name", chunk_attributes: {id: @shared.chunk.id, title: "A New Title"}}
      response.should redirect_to admin_shared_chunks_path
      @shared.reload.name.should == "A New Name"
      @shared.chunk.title.should == "A New Title"
    end
    
    it "fails on validation errors" do
      put :update, use_route: "chunks", id: @shared, shared_chunk: {name: "", chunk_attributes: {id: @shared.chunk.id, title: "A New Title"}}
      response.status.should == 500
      response.should render_template "chunks/admin/shared_chunks/edit"
      @shared.chunk.reload.title.should == "Title From FactoryGirl"      
    end
    
    it "fails on validation errors for associated chunk" do
      put :update, use_route: "chunks", id: @shared, shared_chunk: {chunk_attributes: {id: @shared.chunk.id, title: "A New Title", content: ""}}
      response.status.should == 500
      response.should render_template "chunks/admin/shared_chunks/edit"
      @shared.chunk.reload.title.should == "Title From FactoryGirl"
    end
  end
  
  it "unshares a chunk" do
    @shared = FactoryGirl.create(:shared_chunk)
    delete :destroy, use_route: "chunks", id: @shared
    response.should redirect_to admin_shared_chunks_path
    -> { @shared.reload }.should raise_error ActiveRecord::RecordNotFound
  end
end