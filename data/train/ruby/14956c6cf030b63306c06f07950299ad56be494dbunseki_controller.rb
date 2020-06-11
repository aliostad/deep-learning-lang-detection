# encoding: utf-8
require 'CaboCha'
require 'kconv'
require 'pp'
class BunsekiController < ApplicationController
	def index

		sentence = 'CaboChaのテストをしています'
		parser = CaboCha::Parser.new('--charset=UTF8')
		tree = parser.parse(sentence)

		(0 ... tree.chunk_size).each do |i|
			chunk = tree.chunk(i)

        	# 全てのtokに対して
        	(0 ... chunk.token_size).each do |j|
        		puts tree.token(chunk.token_pos + j).normalized_surface
        	end
		end

		render :text => 'test'
	end
end
