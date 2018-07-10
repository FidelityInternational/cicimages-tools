module Github
  module Api
    module Mocks
      module Issue
        class CreateRequest
          attr_reader :data

          def initialize(data:)
            @data = data
          end

          def title
            data[:title]
          end

          def id
            data[:id]
          end
        end
      end
    end
  end
end
