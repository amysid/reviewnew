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

  def get_expert_average id , type
    @categories = []
    @data = []
    categories = []
    data = []
    @index = nil
    @product = Product.find_by(id: id)
    category_id = @product.category_id
    @rating = Review.average_reviews(category_id, type)
    if @rating.present?
      # last = @rating.last["average_reviews"]
      # first = @rating.first["average_reviews"]
      # ranges = (last - first)/3 + 1
      # if ranges.eql?(0)
      #   categories = [first..first+2]
      # else
      #   i = first
      #   (1..ranges).each do
      #     categories << [i..i+2]
      #     i+=3
      #   end
      # end

      # categories.each {|c| 
      #   @rating.each {|r|
      #     data << r["average_reviews"] if c[0].include?(r["average_reviews"]) && !data.include?(r["average_reviews"])
      #   }
      # }
      data = ActiveSupport::JSON.decode(@rating.to_json).pluck("id","average_reviews").uniq rescue []
      # if data.blank?
      #   start_point = data.min 
      #   end_pont =  data.max
      #   diffrence = start_point % 3
      #   start_point = start_point - diffrence unless diffrence == 0
      #   end_pont = end_pont + diffrence unless diffrence == 0
      # else
      #   start_point = data.min 
      #   end_pont =  data.max
      # end

      data.each{|rating| 
        start_point = rating[1]
        diffrence = start_point % 3
        start_point = start_point - diffrence unless diffrence == 0
        created_string = "#{start_point}-#{((start_point+2) > 100) ? 100 : (start_point+2) }"
        unless @categories.include?(created_string)
          @categories << created_string
          @data << rating[1]
          @index =  @categories.index(created_string) if rating[0] == id
        else
          @index =  @categories.index(created_string) if rating[0] == id
        end 
      }
      # i=0
      # categories.each {|c|
      #     binding.pry
      #   if c[0].include?(data[i]) && !@data.include?(data[i])
      #     @data << data[i]
      #     @categories <<  c.join("").gsub!('..', '-')
      #   end  
      #   i+=1
      # }
      # 
      # binding.pry
      # @index = @data.index(@rating.find(params[:product_id]).as_json["average_reviews"]) rescue nil
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