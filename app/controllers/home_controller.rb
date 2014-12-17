class HomeController < ApplicationController
	before_filter :signed_in_user
	before_filter :ctf_opened
	def index
		@problems = Problem.all
		@develop1_problems = Problem.where("category = ?",'develop1').order('point ASC')
		@develop2_problems = Problem.where("category = ?",'develop2').order('point ASC')
		@develop3_problems = Problem.where("category = ?",'develop3').order('point ASC')
		@google_problems = Problem.where("category = ?",'google').order('point ASC')
		@game_problems = Problem.where("category = ?",'game').order('point ASC')
		@trivial_problems = Problem.where("category = ?",'trivial').order('point ASC')
		@solve = Solve.new

		@solves = Solve.all
		@penalties = Penalty.all

		@logs = Solve.find_by_sql('SELECT "1" type, A1.id uid, A1.name uname, A2.name pname, A2.id pid, datetime(A3.created_at,"localtime") time FROM users A1, problems A2, solves A3 WHERE A1.id = A3.user_id and A2.id = A3.problem_id
		UNION SELECT "2" type, A1.id uid, A1.name uname, A2.percentage penalty, 0, datetime(A2.created_at,"localtime") time FROM users A1, penalties A2 where A1.id = A2.user_id ORDER BY time DESC LIMIT 20')
		
	end

	def delete_admin
		if( is_admin? )
			@admin = Admin.find(params[:id])
			@admin.destroy
			redirect_to '/admin'
		else
			redirect_to '/home', notice: 'Access Denied'
		end
	end

	def create_admin
		if( is_admin? )
			@admin = Admin.new
			@admin.email = params[:admin]
			@admin.save
			redirect_to '/admin'
		else
			redirect_to '/home', notice: 'Access Denied'
		end
	end

	def admin
		if( is_admin? )
			@users = User.all
			@penalty = Penalty.new
			@admins = Admin.all
			@status = Gamestatus.last
		else
			redirect_to '/home', notice: 'Access Denied'
		end
	end

end
