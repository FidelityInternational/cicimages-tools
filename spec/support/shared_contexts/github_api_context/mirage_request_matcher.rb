class MirageRequestMatcher < RSpec::Matchers::DSL::Matcher
  attr_reader :expectations, :template_id, :mirage, :state, :api_name

  def initialize(matcher_execution_context, mirage, state_class, api_name)
    @state = state_class.new
    @expectations = {}
    @mirage = mirage
    @api_name = api_name
    super :_not_set, proc {}, matcher_execution_context
  end

  def expects(expectation)
    expectations.merge!(expectation)
    self
  end

  def with_uri(uri)
    state.endpoint(uri)
    put(state)
  end

  def do_something_on_mirage(_mock_response_class)
    after_actions << self unless after_actions.include?(self)
    put(state)
  end

  alias matches? do_something_on_mirage

  def validate
    raise failure_message if mirage.requests(template_id).empty?
  end

  def failure_message
    <<~MESSAGE
      "#{api_name} not called:
      Request Requirements:
      \t path: #{state.endpoint}
      \t method: #{state.http_method}
      \t required body_content: #{state.required_body_content}
      \t required headers: #{state.required_headers}
      \t required required request parameters: #{state.required_parameters}
    MESSAGE
  end

  def and_return(response)
    @state = response
    put(state)
  end

  private

  def put(state)
    apply_expectations(state)
    mirage.templates(template_id).delete if template_id
    @template_id = mirage.put(state).id
    self
  end

  def apply_expectations(state)
    expectations.each do |key, value|
      raise "api doest support attribute #{key}" unless state.respond_to?(key)
      state.public_send(key, value) unless state.required_body_content.find { |content| content.include?(key.to_s) }
    end
  end
end
