module CommonConcern

  def convert_flash
    #p "converting flash"
    flash.map{|k,v| flash[k] = [v] if v.class == String  }
    yield
  end

  def check_flash
    flash.present?
  end


 def user_search
    if params[:search]
      @search_params =  params.require(:search).permit(:search,:status,:start,:end).to_h
      @search = @search&.where(get_query,@search_params)
    else
      @search
    end
  end

  def get_expert_average id
    @expert_categories = []
    @expert_data = []
    expert_categories = []
    data = []

    @product = Product.find_by(id: id)
    category_id = @product.category_id
    @expert_rating = Review.average_reviews(category_id, "Expert User")
    if @expert_rating.present?
      last = @expert_rating.last["average_reviews"]
      first = @expert_rating.first["average_reviews"]
      ranges = (last - first)/3 + 1
      if ranges.eql?(0)
        expert_categories = [first..first+2]
      else
        i = first
        (1..ranges).each do
          expert_categories << [i..i+2]
          i+=3
        end
      end
      expert_categories.each {|c| 
        @expert_rating.each {|r|
          data << r["average_reviews"] if c[0].include?(r["average_reviews"]) && !data.include?(r["average_reviews"])
        }
      }
      i=0
      expert_categories.each {|c|
        if c[0].include?(data[i]) && !@expert_data.include?(data[i])
          @expert_data << data[i]
          @expert_categories <<  c.join("").gsub!('..', '-')
          i+=1
        end  
      }
      @expert_index = @expert_data.index(@expert_rating.find(params[:product_id]).as_json["average_reviews"]) rescue nil
    end  
  end

  def get_normal_average id
    @normal_categories = []
    @normal_data = []
    normal_categories = []

    @product = Product.find_by(id: id)
    category_id = @product.category_id
    @normal_rating = Review.average_reviews(category_id, "Normal User")
    data = []
    if @normal_rating.present?
      last = @normal_rating.last["average_reviews"]
      first = @normal_rating.first["average_reviews"]
      ranges = (last - first)/3 + 1
      if ranges.eql?(0)
        normal_categories = [first..first+2] 
      else
        i = first
        (1..ranges).each do
          normal_categories << [i..i+2]
          i+=3
        end
      end
      normal_categories.each {|c| 
        @normal_rating.each {|r|
          data << r["average_reviews"] if c[0].include?(r["average_reviews"]) && !data.include?(r["average_reviews"])
        }
      }
      i=0
      normal_categories.each {|c|
        if c[0].include?(data[i]) && !@normal_data.include?(data[i])
          @normal_data << data[i]
          @normal_categories << c.join("").gsub!('..', '-')
          i+=1
        end
      }
      @normal_index = @normal_data.index(@normal_rating.find(params[:product_id]).as_json["average_reviews"]) rescue nil
    end
  end

 def get_query
    query= Set.new
    @search_params = @search_params.collect{|k,v| [k.to_sym,v.strip] if v.present? }.compact.to_h
    @search_params[:search] = "%#{@search_params[:search]}%"
    # @search_params[:status] = (@search_params[:status] == "true") if @search_params[:status]
    @search_params.map{|k,v|
      query << "(name ILIKE :#{k} OR email ILIKE :#{k})" if k == :search
      if k == :status && @search_params[:status].present?
         query << "(user_type ILIKE :#{k})"
      end
    #  query << "status = :#{k}" if k == :status
      if k == :start && @search_params[:start].present? && @search_params[:end].present?
        query << "Date(created_at) BETWEEN :#{k} AND :end"
      elsif (k == :start || k == :end) && query.length < 3
        query << "Date(created_at) >= :#{k}" if k == :start && @search_params[:start].present?
        query << "Date(created_at) <= :#{k}" if k == :end && @search_params[:end].present?
      end
    }
    query.to_a.join(' AND ')
  end

end