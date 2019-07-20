class Admin::FeedbacksController < ApplicationController
	before_action :authenticate_user!
    before_action :find_feedback, only: [:show,:destroy] 
    layout 'admin_lte_2'

    def index
     if params[:created_at].present?
           x=params[:created_at][0,2]
           params[:created_at][0,2]=params[:created_at][3,2]
           params[:created_at][3,2]=x
           @feedbacks = Contact.where(created_at: params[:created_at].to_date.beginning_of_day..params[:created_at].to_date.end_of_day).order("created_at desc").paginate(:page => params[:page], :per_page => 100)
      else

         @feedbacks = Contact.all.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
     end
   @s_no=0
    end




     def show
     	
     end


    def destroy
      if @feedback.destroy
      redirect_to  admin_feedbacks_path
      flash[:notice] = 'Delete feedback succesfully'
    else
      flash[:error] = @user.errors.full_messages.first
      redirect_to  admin_feedbacks_path
      flash[:notice] = 'feedback is not delete'
    end
    end

    private
     def find_feedback
		@feedback = Contact.find_by(id: params[:id])
		redirect_to admin_feedbacks_path unless @feedback
	 end
end
