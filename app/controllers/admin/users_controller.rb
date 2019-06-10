class Admin::UsersController < Admin::AdminApplicationController
 before_action :find_content, only: [:show,:edit,:update,:status,:destroy]
 layout 'admin_lte_2'
 
  def index
  	# binding.pry
    @sr_no = 0
    @users = User.where(role: "user")
    # @users = @users.decorate
    respond_to do |format|
    format.html
    format.csv { send_data @users.to_csv }
   end
  end

  def show
  	# binding.pry
  	# @users = User.find_by(id: params[:id])
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







private
  def find_content
    @user = User.find_by(id: params[:id])
    redirect_to admin_users_path unless @user
  end
  def user_params
    params.require(:user).permit(:name, :mobile_no)
  end
end
