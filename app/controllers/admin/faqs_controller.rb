class Admin::FaqsController < ApplicationController
before_action :authenticate_user!
before_action :find_faqs, only: [:show,:edit,:update,:destroy] 
 layout 'admin_lte_2'

        def index
        	@s_no = 0
        	@faqs = Faq.order("created_at desc").paginate(:page => params[:page], :per_page => 5)
        end

        def create
        	# binding.pry
        	@faqs = Faq.new(faq_params)
        	if @faqs.save
        		redirect_to admin_faqs_path
        		flash[:notice] = "Faq create succesfully"
        	else
        		redirect_to new_admin_faq_path
        		flash[:notice] = "Faq is not create"
        	end
        end
         

         def show
	     end

	     def edit
       	 end
        
         def update
          # binding.pry
  			if @faqs.update_attributes(faq_params)
        		redirect_to admin_faqs_path, notice: 'faqs updated Successfully.'
      		else
        	     flash[:notice] = @faqs.errors.full_messages
        	     render 'edit'
      	    end
         end

        def destroy
  	       if @faqs.destroy
  		       redirect_to admin_faqs_path
  	      else
  		       redirect_to admin_faqs_path
  	       end
        end

        private
        def faq_params
        	params.require(:faqs).permit(:question, :answer)
        end

        def find_faqs
		@faqs = Faq.find_by(id: params[:id])
		redirect_to new_admin_faq_path unless @faqs
	    end
end
