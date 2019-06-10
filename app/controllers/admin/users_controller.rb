class Admin::UsersController < Admin::AdminApplicationController
 before_action :find_content, only: [:show,:edit,:update,:status,:destroy]
 layout 'admin_lte_2'
 
  def index
  	# binding.pry
    @sr_no = 0
    @users = User.where(role: "user")
    respond_to do |format|
    format.html
    format.csv { send_data @users.to_csv }
    end
     @users = @users.decorate
 end

  def show
  	# binding.pry
    # @users = User.find_by(id: params[:id])
  	@users = User.decorate
  end

  def edit
  end
   
  

 def update
    # binding.pry
    @user = User.find_by(id: params[:id])
    if @user.update_attributes(user_params)
       redirect_to admin_users_path
      else
        flash[:alert] = @user.errors.full_messages
        redirect_to admin_users_path
    end
  end
  
   def destroy
    if @user.destroy
      redirect_to  admin_users_path
      flash[:success] = 'succesfull destroy'
    else
      flash[:error] = @user.errors.full_messages.first
      redirect_to  admin_users_path
    end
  end

 def status
    # binding.pry
    @user.status? ? @user.update(status: false) : @user.update(status: true)
    flash[:notice] = "User status changed successfully."
    redirect_back(fallback_location: admin_users_path)
end






private
  def find_content
    @user = User.find_by(id: params[:id])
    redirect_to admin_users_path unless @user
  end
  def user_params
    params.require(:user).permit(:name, :mobile_no, image_attributes: [:id, :file, :_destroy])
  end

  

end
