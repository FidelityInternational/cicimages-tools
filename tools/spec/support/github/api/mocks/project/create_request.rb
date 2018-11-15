module Github
  module Api
    module Mocks
      module Project
        class CreateRequest
          attr_reader :data

          def initialize(data)
            @data = data
          end

          def has_name?(name)
            data[:name] == name
          end

          def id
            data[:id]
          end
        end
      end
    end
  end
end
