class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:destroy, :index, :edit, :show, :update]
	before_filter :ctf_opened, only: [:destroy, :index, :edit, :show, :update]
	# GET /users
  # GET /users.xml
  def index
    if( is_admin? )
  		@users = User.all
      respond_to do |format|
        format.html # index.html.erb
        format.json {render :json => @users.collect{|x| x.email} }
      end
    else
      redirect_to "/home", notice: "Access Denied"
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
		
		@res = Solve.find_by_sql('SELECT SUM (A2.point) points FROM solves A1, problems A2 WHERE A1.problem_id = A2.id and A1.user_id = %d GROUP BY A1.user_id'%params[:id])
		if(@res != [])
			@score = @res.first['points']
		else
			@score = 0
		end
		@solved = Solve.find_by_sql('SELECT A1.name name, A1.id id FROM problems A1, solves A2 WHERE A1.id = A2.problem_id and A2.user_id = %d ORDER BY A2.created_at ASC'%params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /users/1/edit
  def edit
		if (current_user?(User.find(params[:id])) || is_admin?)
    	@user = User.find(params[:id])
		else
			redirect_to user_path, notice: "Access Denied"
		end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    if (current_user?(User.find(params[:id])) || is_admin?)
      @user = User.find(params[:id])
      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
      end
    else
      redirect_to user_path, notice: "Access Denied"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
		if(is_admin?)
	    @user = User.find(params[:id])
 	  	@user.destroy
	    respond_to do |format|
 	    	format.html { redirect_to(users_url) }
 	    	format.xml  { head :ok }
			end
		else
			redirect_to user_path, notice: 'Access Denied'
    end
  end
end
