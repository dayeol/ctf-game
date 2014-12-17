class SolvesController < ApplicationController
	before_filter :signed_in_user
	before_filter :ctf_opened
	def index

		@users = User.all

		@ranking_unsorted = []
		uid = current_user.id
		@users.each do |user|
			if( user.score > 0 )
				@ranking_unsorted.append( user_id: user.id, name: user.name, rank: 1, points: user.score )
			end
		end

		@ranking_unsorted.sort_by! { |e| -e[:points] }

		rank = 1
		@ranking = []
		@ranking_unsorted.each do |record|
			@ranking.append( user_id: record[:user_id], rank: rank, name: record[:name], points: record[:points] )
			if(record[:user_id] == uid)
				@myscore = record[:points]
				@myrank = rank
			end
			rank += 1
		end
		#@uid = current_user.id

		#@res = Solve.find_by_sql('SELECT A3.id id, A3.name name, SUM (A2.point) points, MAX (A1.created_at) time FROM solves A1, problems A2, users A3 WHERE A3.id = A1.user_id and A1.problem_id = A2.id GROUP BY A1.user_id ORDER BY points DESC, time ASC')

		#@ranking = []
		#@myrecord = []
		#@rank = 1
		#@res.each do |record|
		#	if(record['id'] == @uid)
				#@myscore = record['points']
		#		@myrank = @rank
		#	end
		#	@ranking.append( :user_id=> record['id'], :rank=> @rank ,:name => record['name'], :points => record['points'] )
		#	@rank += 1
		#end

		#@myscore = current_user.score

		#@myrecord.append(:points => @myscore, :rank => @myrank)
	end
	
	def create
		if( !isGameActive )
			render :json => { :result => "closed"}
			return
		end

		@pid = params[:try][:pid]
		@key = params[:try][:key]
		@uid = current_user.id
		@email = current_user.email

		if (Solve.where('user_id = ? and problem_id = ?',@uid, @pid).limit(1).count != 0)
			render :json => { :result => 'already'}
		else
			@problem = Problem.find(@pid)
			if(@problem.key == @key)
				@solve = Solve.new
				@solve.user_id = @uid
				@solve.problem_id = @pid
				@solve.save
				render :json => { :result => 'ok'}
			else
				render :json => { :result => 'fail'}
			end
		end
	end
	
	def solved
		@uid = current_user.id
		@solved = Solve.where('user_id = ?',@uid)
		@list = []
		@solved.each do |sol|
			@list.append(sol.problem_id)
		end
		render :json => { :solved => @list }
	end

	def ranking
		@users = User.all

		@ranking_unsorted = []
		uid = current_user.id
		@users.each do |user|
			if( user.score > 0 )
				@ranking_unsorted.append( user_id: user.id, name: user.name, rank: 1, points: user.score )
			end
		end

		@ranking_unsorted.sort_by! { |e| -e[:points] }

		rank = 1
		@ranking = []
		@ranking_unsorted.each do |record|
			@ranking.append( user_id: record[:user_id], rank: rank, name: record[:name], points: record[:points] )
			if(record[:user_id] == uid)
				@myscore = record[:points]
				@myrank = rank
			end
			rank += 1
		end
		@myrecord = []


		@myrecord.append({:points => @myscore, :rank => @myrank})

		render :json => { :top => @ranking, :record => @myrecord}


	end
end
