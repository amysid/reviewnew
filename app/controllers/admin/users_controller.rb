class Admin::UsersController < Admin::AdminApplicationController
 before_action :authenticate_user!
 before_action :find_content, only: [:show,:edit,:update,:status,:destroy,:update_admin_profile]
 layout 'admin_lte_2'
 
    def index
        @sr_no = 0
        @search = User.where(role: "user").order("created_at desc").paginate(:page => params[:page], :per_page => 5)
        @users_count = @search.count
        @users = user_search
        respond_to do |format|
           format.html
           format.csv { send_data @users.to_csv }
        end

        @users = @users.decorate
    end

    
   
    def show
  	     @users = User.decorate
    end

    

    def edit
    end

    def type_user
      @normal_user = User.find_by(id: params[:id]).update(user_type: "Normal User")
      redirect_to admin_users_path
      flash[:notice] = "User Type (Normal User) Change Succesfully"
    end

    def expert_user
      @expert_user = User.find_by(id: params[:id]).update(user_type: "Expert User")
      redirect_to admin_users_path
      flash[:notice] = "User Type (Expert User) Change Successfully"
    end
   
    def import
       User.import(params[:file])
       redirect_to admin_users_path
       flash[:notice] = "File Import Successfully"
    end
  

    def update
        if @user.update_attributes(user_params)
          if @user.image.present?
                 @user.image.update(file: params[:user][:image])
                 @user.update(user_type: params[:user][:user_type])
                 redirect_to admin_users_path
                 flash[:notice] = "User Profile Update Successfully"
             else
                 @user.create_image(file: params[:user][:image])
                 @user.update(user_type: params[:user][:user_type])
                 redirect_to admin_users_path
                 flash[:notice] = "User Profile Update Succesfully"
          end
        else
           flash[:alert] = @user.errors.full_messages
           flash[:notice] = "User Profile Not Update."
           redirect_to admin_users_path
        end
    end
  
   def destroy
    if @user.destroy
      redirect_to  admin_users_path
      flash[:notice] = 'User Deleted Successfully'
    else
      flash[:error] = @user.errors.full_messages.first
      redirect_to  admin_users_path
      flash[:notice] = 'User Not Delete'
    end
   end

   def admin_profile
      @user = User.find_by(id: params[:id])
   end

  def edit_admin_profile
    @user = User.find_by(id: params[:id])
  end

  def update_admin_profile
      if @user.update_attributes(admin_params)
      if @user.image.present?
             @user.image.update(file: params[:user][:image])
             redirect_to admin_users_path
             flash[:notice] = "Admin Profile Update Successfully"
         else
             @user.create_image(file: params[:user][:image])
             redirect_to admin_users_path
             flash[:notice] = "Admin Profile Update Succesfully"
      end
     else
         flash[:notice] = "Admin profile not update."
         redirect_to admin_profile_admin_user_path
     end
  end
    
 def status 
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
    params.require(:user).permit(:name, :mobile_no)
  end
  def admin_params
    params.require(:user).permit(:name, :mobile_no)
  end
  
end
