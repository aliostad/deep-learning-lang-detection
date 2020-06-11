$:.unshift File.join(File.dirname(__FILE__), '../../..')
require 'spec_helper.rb'

describe '/admin/sections/_show' do

  before(:each) do
    @chunk = mock_model(Chunk, :name => 'foo')
    @section = mock_model(Section, :chunks => [@chunk], :name => 'foo')
    assigns[:section] = @section
  end

  it 'renders links to view chunks' do
    render
    response.should have_tag("a[href=#{admin_section_chunk_path(@section, @chunk)}]",
      @chunk.name)
  end

  it 'renders links to edit chunks' do
    render
    response.should have_tag("a[href=#{edit_admin_section_chunk_path(@section, @chunk)}]",
      'Edit')
  end

  it 'renders link to create new chunk' do
    render
    response.should have_tag("a[href=#{new_admin_section_chunk_path(@section)}]",
      'Add Chunk')
  end
end
