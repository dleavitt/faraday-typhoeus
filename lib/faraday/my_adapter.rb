# frozen_string_literal: true

require_relative 'adapter/my_adapter'
require_relative 'my_adapter/version'

module Faraday
  module MyAdapter
    # Faraday allows you to register your middleware for easier configuration.
    # This step is totally optional, but it basically allows users to use a custom symbol (in this case, `:my_adapter`),
    # to use your adapter in their connections.
    # After calling this line, the following are both valid ways to set the adapter in a connection:
    # * conn.adapter Faraday::Adapter::MyAdapter
    # * conn.adapter :my_adapter
    # Without this line, only the former method is valid.
    Faraday::Adapter.register_middleware(my_adapter: Faraday::Adapter::MyAdapter)
  end
end
