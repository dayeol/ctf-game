class GamestatusController < ApplicationController
	def show
		@status = Gamestatus.last
		if @status.nil?
			render :json => { status: "closed"}
		else
			render :json => { status: @status.status }
		end
	end

	def set
		if( is_admin? )
			Gamestatus.destroy_all
			@status = Gamestatus.new( status: params[:status] )
			@status.save

			render :json => { status: @status.status }
		else
			redirect_to '/home', notice: "Access Denied"
		end
	end
end
