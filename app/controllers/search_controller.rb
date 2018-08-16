class SearchController < ApplicationController

  def find
    @available_indices = %w(questions answers comments users)
    @result, @count_results = ItemsFinder.call(search_area, sanitaized_search_field)
  end

  private

  def sanitaized_search_field
    ThinkingSphinx::Query.escape(params[:search_field] || '')
  end

  def search_area
    result = @available_indices & params.keys
    result.empty? ? @available_indices : result
  end
end
