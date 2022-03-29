# frozen_string_literal: true

RSpec.describe Faraday::MyAdapter do
  it 'has a version number' do
    expect(Faraday::MyAdapter::VERSION).to be_a(String)
  end
end
