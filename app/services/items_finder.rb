class ItemsFinder < ApplicationServices

  def initialize(search_area, search_string)
    @search_area = search_area
    @search_string = search_string
  end

  def call
    result = {}
    count_results = 0

    @search_area.each do |item|
      item_search_result = item.classify.constantize.search(@search_string) || []
      count_results += item_search_result.size
      result[item] = item_search_result unless item_search_result.empty?
    end
    return result, count_results
  end
end
