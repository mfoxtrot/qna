require 'rails_helper'

describe ItemsFinder do

  context '.call' do
    let!(:search_area) { %w(questions answers comments user) }
    let!(:search_string) { 'test' }
    let(:method_call) { ItemsFinder.call(search_area, search_string) }

    it 'calls search method for each class in class_area' do
      search_area.each do |item|
        expect(item.classify.constantize).to receive(:search).with(search_string)
      end
      method_call
    end

    it 'returns first value as a hash' do
      expect(method_call[0]).to be_kind_of(Hash)
    end

    it 'returns second value as an Integer' do
      expect(method_call[1]).to be_kind_of(Integer)
    end
  end
end
