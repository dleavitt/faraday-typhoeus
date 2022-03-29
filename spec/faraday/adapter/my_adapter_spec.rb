# frozen_string_literal: true

RSpec.describe Faraday::Adapter::MyAdapter do
  # Since not all adapters support all the features Faraday has to offer, you can use the `features` method to turn on
  # only the ones you know you can support.
  # TODO: provide the full list of available features!
  features :request_body_on_query_methods,
           :reason_phrase_parse,
           :compression,
           :streaming,
           :trace_method

  # Runs the tests provide by Faraday, according to the features specified above.
  it_behaves_like 'an adapter'

  # You can then add any other test specific to this adapter here...
end
