module Github
  module Api
    module Mocks
      module Repos
        class EditRequest
          attr_reader :data

          def initialize(data)
            @data = data
          end
        end
      end
    end
  end
end
