# -*- coding: utf-8 -*-
require 'spec_helper'

describe ChunksHelper do

  let(:chunk) { Factory(:chunk) }

  describe "#link_to_download_chunk" do
    
    context "when the Chunk is completed" do

      before(:each) do
        chunk.stub :status => ActiveSupport::StringInquirer.new("completed")
      end
      
      describe "the link" do

        subject { helper.link_to_download_chunk(chunk) }
        
        it "should have 'Télécharger' as name" do
          subject.should have_tag("a", "Télécharger")
        end

        it "should go to source_chunk_path with wav format" do
          chunk.format = :mp3
          subject.should have_tag("a[href=?]", source_chunk_path(chunk.source, chunk, :format => "mp3"))
        end

        it "should have class 'download'" do
          subject.should have_tag("a[class=download]") 
        end

      end
                                      
    end

    context "when the Chunk isn't completed" do

      before(:each) do
        chunk.stub :status => ActiveSupport::StringInquirer.new("not completed")
      end
      
      describe "the link" do

        subject { helper.link_to_download_chunk(chunk) }
        
        it "should have 'En préparation' as name" do
          subject.should have_tag("a", "En préparation")
        end

        it "should go to source_chunk_path" do
          subject.should have_tag("a[href=?]", source_chunk_path(chunk.source, chunk))
        end

        it "should have class 'download-pending'" do
          subject.should have_tag("a[class=download-pending chunk]") 
        end

        it "should have title 'Vérifier l'état" do
          subject.should have_tag('a[title="Vérifier l\'état"]') 
        end

      end
                                      
    end

  end

end
