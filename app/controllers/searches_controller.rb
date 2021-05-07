class SearchesController < ApplicationController
  def search
    if params[:search_in] != nil
      type = params['/search/search'][:type]
      if type != 'All'
        type = type.classify.constantize
      else
        type = 'ThinkingSphinx'.classify.constantize
      end
      search_in = params[:search_in]
      @results = type.search(search_in) unless search_in == '' || search_in.nil?
    end
  end
end
