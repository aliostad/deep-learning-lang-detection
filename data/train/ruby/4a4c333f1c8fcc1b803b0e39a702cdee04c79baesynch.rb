require 'simperium'
auth = Simperium::Auth.new('proficiency-stitches-d7f', '1c3b994783a6430e9f6f595a1be93c38')
#@token = auth.create('email1@address.com', 'password')
@token = auth.authorize('email1@address.com', 'password')

#Talking to Simperium
api = Simperium::Api.new('proficiency-stitches-d7f', @token)
@chunk = api.chunk

#@chunkid = api.chunk.new({'title3' => '3'})

#@showchunk = api.chunk.get('b7da1f500a5c0130e5c5704da27e5162')

api.chunk.set("516c5b800a840130e85f704da27e5162",{"a8"=>"b23"})

#api.chunk.delete('3252e9600a8b0130f735704da27e5162')

#puts @showchunk

