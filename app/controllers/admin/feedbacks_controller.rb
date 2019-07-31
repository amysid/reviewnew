class Admin::FeedbacksController < ApplicationController
	before_action :authenticate_user!
  before_action :find_feedback, only: [:show,:destroy] 
  layout 'admin_lte_2'

    def index
      @s_no = 0
     if params[:date].present?
           x=params[:date][0,2]
           params[:date][0,2]=params[:date][3,2]
           params[:date][3,2]=x
           @feedbacks = Contact.where(created_at: params[:date].to_date.beginning_of_day..params[:date].to_date.end_of_day).order("created_at desc").paginate(:page => params[:page], :per_page => 100)
      else
           @feedbacks = Contact.all.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
      end
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
