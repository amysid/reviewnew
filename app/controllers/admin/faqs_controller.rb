class Admin::FaqsController < ApplicationController
before_action :authenticate_user!
before_action :find_faqs, only: [:show,:edit,:update,:destroy] 
 layout 'admin_lte_2'

        def index
        	@s_no = 0
        	@faqs = Faq.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
        end

        def create
        	
        	@faqs = Faq.new(faq_params)
        	if @faqs.save
        		redirect_to admin_faqs_path
        		flash[:notice] = "Faq create succesfully"
        	else
        		redirect_to new_admin_faq_path
            flash[:alert] = @faqs.errors.full_messages
        		flash[:notice] = "Faq is not create"
        	end
        end
         

         def show
	     end

	     def edit
       	 end
        
         def update
         
  			if @faqs.update_attributes(faq_params)
        		redirect_to admin_faqs_path, notice: 'faqs updated Successfully.'
      		else
        	     flash[:alert] = @faqs.errors.full_messages
        	     render 'edit'
               flash[:notice] = "faq is not update"
      	    end
         end

        def destroy
  	       if @faqs.destroy
             flash[:notice] = "Faq delete succesfully"
  		       redirect_to admin_faqs_path
  	      else
            flash[:alert] = @faqs.errors.full_messages
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
