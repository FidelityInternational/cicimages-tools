module Github
  module Api
    module Mocks
      module Project
        module Column
          class CreateRequest
            attr_reader :data, :project_id

            def initialize(data:, project_id:)
              @data = data
              @project_id = project_id.to_i
            end

            def name
              data[:name]
            end
          end
        end
      end
    end
  end
end
