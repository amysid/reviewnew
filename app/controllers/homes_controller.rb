class HomesController < ApplicationController
	def about_us
        @about = StaticContent.find_by(title: "About us")
    end

    def faq
       @faqs = Faq.all
    end
    def contact_us
         @contact = StaticContent.find_by(title: "Contact us")
         @trending = Product.where(trending: true).last(4)
    end

    def privacy_policy
        @privacy = StaticContent.find_by(title: "Privacy Policy")
     end

    def term_condition
        @term_condition = StaticContent.find_by(title: "Terms & Conditions")
    end

    def create
        @feedback = Contact.new(feedback_params)
        if @feedback.save
            redirect_to feedback_homes_path
            flash[:notice] = "Feedback submitted"
        else
            redirect_to feedback_homes_path
            flash[:notice] = "Feedback not submitted"
        end
    end

    def feedback
        @upcoming_release =  Product.where('date > ?', Date.today).last(4)
    end

    def feedback_params
        params.require(:contact).permit(:user_feedback)
    end
end
