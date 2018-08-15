class SearchController < ApplicationController
  def find
    @result = {}
    @count_results = 0
    %w(questions answers comments users).each do |class_name|
      class_name_results = class_name.classify.constantize.search(sanitaized_search_field)
      class_name_results ||= []
      @count_results += class_name_results.size
      @result[class_name.to_sym] = class_name_results
    end
  end

  private

  def sanitaized_search_field
    ThinkingSphinx::Query.escape(params[:search_field])
  end
end
