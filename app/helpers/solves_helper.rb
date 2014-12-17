module SolvesHelper

	def rankcolor (rank)
		if rank == 1
			return 0
		elsif rank == 2
			return 2
		elsif rank == 3
			return 4
		elsif rank <= 10
			return 6
		else
			return 7
		end
	end

end
