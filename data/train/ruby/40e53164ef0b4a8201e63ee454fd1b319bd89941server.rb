#!/usr/bin/env ruby
require 'digest/sha2'
require 'fileutils'
require 'openssl'

require 'rubygems'
require 'json'
require 'sass'
require 'sinatra'

# Create the data folders.
FileUtils.mkdir_p 'test/blobs'
FileUtils.mkdir_p 'test/chunks'

# Serve templates from the same folder.
set :views, File.dirname(__FILE__)

helpers do
  def chunk_file(chunk_hash)
    "test/chunks/#{chunk_hash}"
  end
  
  def metadata_file(file_id)
    "test/blobs/#{file_id}.json"
  end
    
  def update_metadata(new_metadata)
    file = metadata_file new_metadata[:id]
    if File.exist?(file)
      metadata = JSON.parse File.read(file)
    else
      metadata = {}
    end
    metadata['mime'] = new_metadata[:mime]
    metadata['size'] = new_metadata[:size]
    metadata['chunks'] ||= {}
    # TODO(pwnall): drop chunks that exceed the file size
    File.open(file, 'w') { |f| f.write JSON.dump metadata } 
  end
  
  def update_chunk(file_id, chunk_data)
    file = metadata_file file_id
    metadata = JSON.parse File.read(file)
    metadata['chunks'][chunk_data[:start].to_s] = { 'hash' => chunk_data[:hash],
        'length' => chunk_data[:length] }
    File.open(file, 'w') { |f| f.write JSON.dump metadata } 
  end
end

# Test HTML.
get '/' do
  send_file 'test/index.html', :disposition => :inline
end
# Test CSS.
get '/stylesheet.css' do
  scss :stylesheet
end
# Test assets.
get '/files/*' do
  send_file File.join(File.dirname(__FILE__), '..', params[:splat])
end

# Upload file metadata.
put '/chunks' do
  file_id = env['HTTP_X_PWNFILER_FILEID']
  chunk_start = env['HTTP_X_PWNFILER_START'].to_i
  chunk_hash = env['HTTP_X_PWNFILER_HASH']
  json = JSON.parse request.body.read
  file_size, mime_type = json['fileSize'], json['mimeType']
  
  update_metadata :id => file_id, :size => file_size, :mime => mime_type
  
  if present = File.exist?(chunk_file(chunk_hash))
    update_chunk file_id, :hash => chunk_hash, :start => chunk_start,
                          :length => File.read(chunk_file(chunk_hash)).length
  end
  [200, {'Content-Type' => 'application/json'}, JSON.dump(:present => present)]
end

# Upload file data.
post '/chunks' do
  chunk = request.body.read
  chunk_hash = OpenSSL::Digest::SHA1.hexdigest chunk
  if chunk_hash != env['HTTP_X_PWNFILER_HASH']
    halt 400, 'Content hash does not match'
    return
  end
  File.open("test/chunks/#{chunk_hash}", 'w') { |f| f.write chunk }
  
  file_id = request['HTTP_X_PWNFILER_FILEID']
  chunk_start = request['HTTP_X_PWFILER_START'].to_i
  update_chunk file_id, :hash => chunk_hash, :start => chunk_start,
                        :length => chunk.length
  200
end

# Download an entire file.
get '/blobs/:id' do
  # TODO(pwnall): code up
end
