class Admin::UsersController < Admin::AdminApplicationController
layout 'admin_lte_2'
  def index
  	@users = User.where(role: "user")
  	@sr_no = 0
  end

  def show
  	# binding.pry
  	@users = User.find_by(id: params[:id])
  end
end
