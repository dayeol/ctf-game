class PenaltyController < ApplicationController
	def new
		@penalty = Penalty.new
	end
	def create
		if(is_admin?)
			@penalty = Penalty.new( params[:penalty] )
			@penalty.giver_id = current_user.id
			@penalty.save
			redirect_to '/penalty'
		else
			redirect_to '/home', notice: 'Access Denied'
		end
	end
end
