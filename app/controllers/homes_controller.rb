class HomesController < ApplicationController
	def about_us
        @about = StaticContent.find_by(title: "About us")
    end

    def faq
    	# binding.pry
    	@faqs = Faq.all
    end
    def contact_us
        # binding.pry
         @contact = StaticContent.find_by(title: "Contact us")
    end

    def privacy_policy
        # binding.pry
        @privacy = StaticContent.find_by(title: "Privacy Policy")
     end

    def term_condition
        @term_condition = StaticContent.find_by(title: "Terms & Conditions")
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
