class Admin::ProductsController < ApplicationController
	before_action :authenticate_user!	
    layout 'admin_lte_2'

    def index
    	# binding.pry
    end

    def new
    end

    def create
    end

    def sub_categories_by_category
    binding.pry
    end
    
end
