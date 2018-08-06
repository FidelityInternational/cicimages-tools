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

            def content_type
              data[:content_type]
            end

            def ==(other)
              data == other.data
            end
          end
        end
      end
    end
  end
end
