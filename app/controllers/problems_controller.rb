class ProblemsController < ApplicationController
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
	end
	def new
		if(is_admin?)
			@problem = Problem.new
		else
			redirect_to problems_path, notice: "Access Denied"
		end
	end
	
	def create
		if(is_admin?)
	    @problem = Problem.new(params[:problem])
			@problem.maker = current_user.id
   		respond_to do |format|
      	if @problem.save
        	format.html { redirect_to(@problem, :notice => 'Problem was successfully created.') }
        	format.xml  { render :xml => @problem, :status => :created, :location => @problem }
     	 	else
        	format.html { render :action => "new" }
        	format.xml  { render :xml => @problem.errors, :status => :unprocessable_entity }
      	end
    	end
		else
			redirect_to problem_path, notice: "Access Denied"
		end
  end
	def show
		@maker = maker_of(params[:id])
		@problem = Problem.find(params[:id])
		@solvers = Solve.find_by_sql('SELECT A1.id id, A1.name name FROM users A1, solves A2 WHERE A1.id = A2.user_id and A2.problem_id = '+params[:id]+' ORDER BY A2.created_at ASC');
		@problem.hint = @problem.hint.gsub(/\n/,'<br />').html_safe
		respond_to do |format|
			format.html
			format.json {render :json => @problem, :only => [:name, :hint, :point, :id, :file]}
		end
	end

	def edit
		if (is_admin? or is_his_problem? params[:id])
			@problem = Problem.find(params[:id])
		else
			redirect_to problem_path, notice: "Access Denied"
		end
	end

	def update
		if(is_admin? or is_his_problem? params[:id])
		
			@problem = Problem.find(params[:id])
			respond_to do |format|
				if @problem.update_attributes(params[:problem])
					format.html {redirect_to(@problem, :notice => 'Problem was successfully updated.') }
				else
					format.html {render :action => "edit"}
				end
			end
		else
			redirect_to problem_path, notice: "Access Denied"
		end
	end

	def destroy
		if(is_admin? or is_his_problem? params[:id])
			@problem = Problem.find(params[:id])
			@problem.destroy
			respond_to do |format|
				format.html {redirect_to (problems_url)}
			end
		else
			redirect_to problems_path, notice: 'Access Denied'
		end
	end
end
