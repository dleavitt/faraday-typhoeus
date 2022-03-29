# frozen_string_literal: true

module Faraday
  class Adapter
    # This class provides the main implementation for your adapter.
    # There are some key responsibilities that your adapter should satisfy:
    # * Initialize and store internally the client you chose (e.g. Net::HTTP)
    # * Process requests and save the response (see `#call`)
    class MyAdapter < Faraday::Adapter
      # The initialize method is lazy-called ONCE when the connection stack is built.
      # See https://github.com/lostisland/faraday/blob/master/lib/faraday/rack_builder.rb
      #
      # @param app [#call] the "rack app" wrapped in middleware. See https://github.com/lostisland/faraday/blob/master/lib/faraday/rack_builder.rb#L157
      # @param opts [Hash] the options hash with all the options necessary for the adapter to correctly configure itself.
      #   These are automatically stored into `@connection_options` when you call `super`.
      # @param block [Proc] the configuration block for the adapter. This usually provides the possibility to access the internal client from the outside
      #   and set properties that are not included in Faraday's API. It's automatically stored into `@config_block` when you call `super`.
      def initialize(app = nil, opts = {}, &block)
        super(app, opts, &block)
      end

      # This is the main method in your adapter. Since an adapter is a middleware, this method will be called FOR EVERY REQUEST.
      # The main task of this method is to perform a call using the internal client and save the response.
      # Since this method is not called directly f`rom the outside, you'll need to use `env` in order to:
      # * Get the request parameters (see `Faraday::Env` and `Faraday::RequestOptions` for the full list). This includes processing:
      #   * The request method, url, headers, parameters and body
      #   * The SSL configuration (env[:ssl])
      #   * The request configuration (env[:request]), i.e. things like: timeout, proxy, etc...
      # * Set the response attributes. This can be done easily by calling `save_response`. These include:
      #   * Response headers and body
      #   * Response status and reason_phrase
      #
      # @param env [Faraday::Env] the environment of the request being processed
      def call(env)
        # First thing to do should be to call `super`. This will take care of the following for you:
        # * Clear the body if the request supports a body
        # * Initialize `env.response` to a `Faraday::Response`
        super

        # Next you want to configure your client for the request and perform it, obtaining the response.
        response = {} # Make call using client

        # Now that you got the response in the client's format, you need to call `save_response` to store the necessary
        # details into the `env`. This method accepts a block to make it easier for you to set response headers using
        # `Faraday::Utils::Headers`. Simply provide a block that given a `response_headers` hash sets the necessary key/value pairs.
        # Faraday will automatically take care of things like capitalising keys and coercing values.
        save_response(env, response.status, response.body, response.headers, response.reason_phrase) do |response_headers|
          response.headers.each do |key, value|
            response_headers[key] = value
          end
        end

        # NOTE: An adapter `call` MUST return the `env.response`. If `save_response` is the last line in your `call`
        # method implementation, it will automatically return the response for you.
        # Otherwise, you'll need to manually do so. You can do this with any (not both) of the following lines:
        # * @app.call(env)
        # * env.response
      # Finally, it's good practice to rescue client-specific exceptions (e.g. Timeout, ConnectionFailed, etc...)
      # and re-raise them as Faraday Errors. Check `Faraday::Error` for a list of all errors.
      rescue MyAdapterTimeout => e
        # Most errors allow you to provide the original exception and optionally (if available) the response, to
        # make them available outside of the middleware stack.
        raise Faraday::TimeoutError, e
      end
    end
  end
end
