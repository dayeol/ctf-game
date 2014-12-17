class PagesController < ApplicationController
  def index
  	@users = User.all
    respond_to do |format|
	  format.html
		end
  end

	def closed
		@users = User.all
		render :closed
	end

	def home
		@correct = Correct.find
	end
end
