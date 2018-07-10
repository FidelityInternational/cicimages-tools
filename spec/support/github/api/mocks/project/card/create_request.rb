module Github
  module Api
    module Mocks
      module Project
        module Card
          class CreateRequest
            attr_reader :data

            def initialize(data:)
              @data = data
            end

            def name
              data[:name]
            end

            def content_id
              data[:content_id]
            end
          end
        end
      end
    end
  end
end
