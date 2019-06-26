class HomesController < ApplicationController
	def about_us
    end

    def faq
    	# binding.pry
    	@faqs = Faq.all
    end

    def privacy_policy
    end

    def term_condition
    end

    def create
        # binding.pry
        @feedback = Contact.new(feedback_params)
        if @feedback.save
            redirect_to feedback_homes_path
            flash[:notice] = "Feedback submitted"
        else
            redirect_to feedback_homes_path
            flash[:notice] = "Feedback not submitted"
        end
    end

    def feedback_params
        # params[:user][:feedback] = params[:user][:feedback]
        params.require(:contact).permit(:user_feedback)
    end
end
