module Mirage
  module RSpec
    module ClassMethods
    end

    module Expectations
      def define_expectation_method(api_method, mock_response_class)
        define_singleton_method api_method do
          @expectation_chain = MirageRequestMatcher.new(self, mirage, mock_response_class.response_class, api_method)
        end
      end

      def define_requests_method(api, fixture)
        define_singleton_method "#{api}_requests", &fixture.finder
      end

      def self.included(clazz)
        clazz.extend ClassMethods
      end

      def be_called
        @expectation_chain
      end

      def be_called_with(attribute_hash)
        @expectation_chain.expects(attribute_hash)
      end

      def with_uri(uri)
        @expectation_chain.with_uri(uri)
      end

      ::RSpec::Matchers.define :have_been_called_with do |message|
        match do |expectation|
          mirage.requests(expectation.template_id).find do |request|
            JSON(request.body)['body'] == message
          end
        end
      end
    end
  end
end

shared_context :mirage do
  include Mirage::RSpec::Expectations

  MIRAGE_CLIENT = Mirage.start

  def mirage
    MIRAGE_CLIENT
  end

  after(:each) do |example|
    after_actions.each(&:call) unless example.exception
  end

  let(:after_actions) do
    @after_actions ||= []
  end
end
