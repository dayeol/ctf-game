require 'digest/md5'
class KeygenController < ApplicationController
	before_filter :ctf_opened
	def generate
		@key = ""
		@file = params[:file]
		if not @file.nil?
			@stream = @file.read
			@stream.gsub! "\r\n", "\n"
			@stream.gsub! "\r", "\n" 
			@stream.gsub! "\t", " "
			@stream.gsub! /[\ ]+/, " "
			@stream.gsub! /[\ ]+\n/, "\n"
			@stream.gsub! "\t", " "
			#마지막 공백 제거
			@stream.gsub! /[\n\ ]+$/, ''
			# none ascii characters 제거
			@stream.gsub! /[^\x00-\x7f]/, ''
			@key = Digest::MD5.hexdigest(@stream)
		end

	end
end
