module ProblemsHelper
	def ctf_opened
		@opened = !(Gamestatus.last.status == "closed")
		if (! @opened && ! is_admin?)
			redirect_to '/not_yet'
		end
	end

	def isGameActive
		@status = Gamestatus.last.status
		return @status == "started"
	end
	
	def is_his_problem?(pid)
		@prob = Problem.find(pid)
		return @prob.maker == current_user.id
	end

	def maker_of(pid)
		@prob = Problem.find(pid)
		return User.find(@prob.maker)
	end
end
