$:.unshift File.join(File.dirname(__FILE__), '../..')
require 'spec_helper.rb'

describe Admin::ChunksController do

  before(:each) do
    @section = mock_model(Section)
    Section.stub!(:find).with(@section.id.to_s).and_return(@section)
    @chunk = mock_model(Chunk)
    Chunk.stub!(:find).with(@chunk.id.to_s).and_return(@chunk)
    @controller.stub!(:check_authorization).and_return(true)
  end

  context 'GET show' do

    it 'assigns @section to section' do
      get :show, :section_id => @section.id, :id => @chunk.id
      assigns[:section].should == @section
    end

    it 'assigns @chunk to chunk' do
      get :show, :section_id => @section.id, :id => @chunk.id
      assigns[:chunk].should == @chunk
    end

    it 'renders site_page_view template' do
      @controller.should_receive(:render).
        with(:template => 'admin/site_page_view',
             :locals => { :partial => 'admin/chunks/show' })
      get :show, :section_id => @section.id, :id => @chunk.id
    end
  end

  context 'GET new' do

    it 'assigns @section to section' do
      get :new, :section_id => @section.id
      assigns[:section].should == @section
    end

    it 'assigns @chunk to new Chunk' do
      Chunk.stub!(:new).and_return(@chunk)
      get :new, :section_id => @section.id
      assigns[:chunk].should == @chunk
    end

    it 'renders site_page_edit template' do
      @controller.should_receive(:render).
        with(:template => 'admin/site_page_edit',
             :locals => { :partial => 'admin/chunks/new' })
      get :new, :section_id => @section.id
    end
  end

  context 'POST create' do

    before(:each) do
      Chunk.stub!(:new).and_return(@chunk)
      @chunks = []
      @section.stub!(:chunks).and_return(@chunks)
    end

    it 'assigns @section to section' do
      post :create, :section_id => @section.id, :chunk => {}
      assigns[:section].should == @section
    end

    it 'creates a new Chunk' do
      Chunk.should_receive(:new).with('foo' => 'bar')
      post :create, :section_id => @section.id, :chunk => { :foo => 'bar' }
    end

    context 'is successful' do

      it 'adds the new Chunk to the section' do
        post :create, :section_id => @section.id, :chunk => {}
        @chunks.should == [@chunk]
      end

      it 'redirects to the new chunk' do
        post :create, :section_id => @section.id, :chunk => {}
        response.should redirect_to(admin_section_chunk_path(@section, @chunk))
      end
    end

    context 'is not successful' do

      it 'renders site_page_edit template' do
        chunks = mock('chunks')
        chunks.stub!(:<<).with(anything).and_return(false)
        @section.stub!(:chunks).and_return(chunks)
        @controller.should_receive(:render).
          with(:template => 'admin/site_page_edit',
               :locals => { :partial => 'admin/chunks/new' })
        post :create, :section_id => @section.id, :chunk => {}
      end
    end
  end

  context 'GET edit' do

    it 'assigns @section to section' do
      get :edit, :section_id => @section.id, :id => @chunk.id
      assigns[:section].should == @section
    end

    it 'assigns @chunk to chunk' do
      get :edit, :section_id => @section.id, :id => @chunk.id
      assigns[:chunk].should == @chunk
    end

    it 'renders site_page_edit template' do
      @controller.should_receive(:render).
        with(:template => 'admin/site_page_edit',
             :locals => { :partial => 'admin/chunks/edit' })
      get :edit, :section_id => @section.id, :id => @chunk.id
    end
  end

  context 'PUT update' do

    before(:each) do
      @chunk.stub!(:update_attributes)
    end

    it 'assigns @section to section' do
      put :update, :section_id => @section.id, :id => @chunk.id, :chunk => {}
      assigns[:section].should == @section
    end

    it 'updates the chunk attributes' do
      @chunk.should_receive(:update_attributes).with('foo' => 'bar')
      put :update, :section_id => @section.id, :id => @chunk.id, :chunk => { :foo => 'bar' }
    end

    context 'is successful' do

      it 'redirects to the updated chunk' do
        @chunk.stub!(:update_attributes).and_return(true)
        put :update, :section_id => @section.id, :id => @chunk.id, :chunk => {}
        response.should redirect_to(admin_section_chunk_path(@section, @chunk))
      end
    end

    context 'is not successful' do

      it 'renders site_page_edit template' do
        @chunk.stub!(:update_attributes).and_return(false)
        @controller.should_receive(:render).
          with(:template => 'admin/site_page_edit',
               :locals => { :partial => 'admin/chunks/edit' })
        put :update, :section_id => @section.id, :id => @chunk.id, :chunk => {}
      end
    end
  end

  context 'DELETE destroy' do

    before(:each) do
      @chunk.stub!(:destroy)
    end

    it 'assigns @section to section' do
      delete :destroy, :section_id => @section.id, :id => @chunk.id
      assigns[:section].should == @section
    end

    it 'destroys the chunk' do
      @chunk.should_receive(:destroy)
      delete :destroy, :section_id => @section.id, :id => @chunk.id
    end

    context 'is successful' do

      it 'redirects to the section' do
        @chunk.stub!(:destroy).and_return(true)
        delete :destroy, :section_id => @section.id, :id => @chunk.id
        response.should redirect_to(admin_section_path(@section))
      end
    end

    context 'is not successful' do

      it 'renders site_page_view template' do
        @chunk.stub!(:update_attributes).and_return(false)
        @controller.should_receive(:render).
          with(:template => 'admin/site_page_view',
               :locals => { :partial => 'admin/chunks/show' })
        delete :destroy, :section_id => @section.id, :id => @chunk.id
      end
    end
  end
end
