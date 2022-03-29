# frozen_string_literal: true

require_relative 'adapter/typhoeus'
require_relative 'typhoeus/version'

module Faraday
  module Typhoeus
    # Faraday allows you to register your middleware for easier configuration.
    # This step is totally optional, but it basically allows users to use a custom symbol (in this case, `:typhoeus`),
    # to use your adapter in their connections.
    # After calling this line, the following are both valid ways to set the adapter in a connection:
    # * conn.adapter Faraday::Adapter::Typhoeus
    # * conn.adapter :typhoeus
    # Without this line, only the former method is valid.
    Faraday::Adapter.register_middleware(typhoeus: Faraday::Adapter::Typhoeus)
  end
end
