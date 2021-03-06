module LatoCore

  # This module contains a list of functions used by controllers to interact with widgets
  # cells.
  module Interface::Cells

    # This function must be executed before every action and set metadata
    # used by cells.
    def core__cells_initialize
      @core__cells_authenticity_token = form_authenticity_token
    end

    # This function manage the widget index from front end.
    def core__widgets_index(records, search: nil, pagination: 50)
      response = {
        records: records,
        total: records.length,
        per_page: pagination,
        search: '',
        search_key: search,
        sort: '',
        sort_dir: 'ASC',
        pagination: 1,
      }

      # manage search
      if search && params[:widget_index] && params[:widget_index][:search] && !params[:widget_index][:search].blank?
        search_array = search.is_a?(Array) ? search : [search]
        query1 = ''
        query2 = []
        search_array.each do |s|
          query1 += "#{s} like ? OR "
          query2.push("%#{params[:widget_index][:search]}%")
        end
        query1 = query1[0...-4]
        query = [query1] + query2
        response[:records] = response[:records].where(query)
        response[:total] = response[:records].length
        response[:search] = params[:widget_index][:search]
      end
      # manage sort
      if params[:widget_index] && !params[:widget_index][:sort].blank? && !params[:widget_index][:sort_dir].blank?
        response[:sort] = params[:widget_index][:sort]
        response[:sort_dir] = params[:widget_index][:sort_dir]
        response[:records] = response[:records].order("#{params[:widget_index][:sort]} #{params[:widget_index][:sort_dir]}")
      end
      # manage pagination
      if pagination
        if params[:widget_index] && params[:widget_index][:pagination]
          response[:pagination] = params[:widget_index][:pagination].to_i
        end
        response[:records] = core__paginate_array(response[:records], pagination, response[:pagination])
      end
      # return response
      response
    end

  end
end