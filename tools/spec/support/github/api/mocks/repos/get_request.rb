module Github
  module Api
    module Mocks
      module Repos
        class GetRequest
          attr_reader :data

          def initialize(data)
            @data = data
          end
        end
      end
    end
  end
end
