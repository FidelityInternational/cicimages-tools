module Github
  module Api
    class Fixture
      attr_reader :finder, :response_class, :request_class, :mirage

      def initialize(response_class:, request_class:, mirage:)
        @response_class = response_class
        @request_class = request_class
        @mirage = mirage
        stub
      end

      def requests
        finder.call
      end

      private

      def stub
        template_id = mirage.put(response_class.new).id
        request_class = request_class()
        @finder = proc do
          mirage.requests(template_id).collect do |request|
            request_class.new(data: request.body)
          end
        end
      end
    end
  end
end
