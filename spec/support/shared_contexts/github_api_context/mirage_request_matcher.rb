class MirageRequestMatcher < RSpec::Matchers::DSL::Matcher
  include RSpec::Mocks::Matchers::Matcher

  attr_reader :expectations, :template_id, :mirage, :state, :api_name

  def initialize(matcher_execution_context, mirage, state_class, api_name)
    @state = state_class.new
    @expectations = {}
    @mirage = mirage
    @api_name = api_name
    super :_not_set, proc {}, matcher_execution_context
  end

  def setup_allowance(*_args)
    put(state)
  end

  def expects(expectation)
    expectations.merge!(expectation)
    self
  end

  def with_uri(uri)
    state.endpoint(uri)
    put(state)
  end

  def does_not_match?(_arg)
    after_actions << proc do
      raise failure_message('should') if called?
    end

    put(state)
  end

  def matches?(_arg)
    after_actions << proc do
      raise failure_message('should NOT') unless called?
    end

    put(state)
  end

  def failure_message(status)
    <<~MESSAGE
      "#{api_name} #{status} have been called:
      TemplateID: #{template_id}
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

  def called?
    !mirage.requests(template_id).empty?
  end

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
