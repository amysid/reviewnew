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
end
