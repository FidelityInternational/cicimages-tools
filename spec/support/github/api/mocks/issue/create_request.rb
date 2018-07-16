module Github
  module Api
    module Mocks
      module Issue
        class CreateRequest
          attr_reader :data

          def initialize(data:)
            @data = JSON(data, symbolize_names: true)
          end

          def title
            data[:title]
          end

          def body
            data[:body]
          end

          def labels
            data[:labels]
          end

          def ==(other)
            title == other.title &&
              labels == other.labels
          end
        end
      end
    end
  end
end
