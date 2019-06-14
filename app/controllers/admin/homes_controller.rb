class Admin::HomesController < ApplicationController
  layout 'admin_lte_2'
  def index
  	# binding.pry
  	@user = User.where(role: "user")
  	@active_user = User.where(status: "true").where(role: "user")
  	@block_user = User.where(status: "false").where(role: "user")
  	@normal_user = User.where(user_type: "Normal User")
  	@expert_user = User.where(user_type: "Expert User")
  end
end
