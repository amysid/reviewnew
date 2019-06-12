class Admin::HomesController < ApplicationController
  layout 'admin_lte_2'
  def index
  	@user = User.where(role: "user")
  end
end
