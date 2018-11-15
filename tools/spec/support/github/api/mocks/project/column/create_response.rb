module Github
  module Api
    module Mocks
      module Project
        module Column
          class CreateResponse
            extend Mirage::Template::Model
            extend Mirage::Template::JSONRequirements

            endpoint '/projects/*/columns'
            content_type 'application/json'
            http_method :post
            json_requirement :name

            attr_reader :id

            def initialize(name: rand(999_999))
              super
              @name = name
              @id = rand(999_999)
            end

            def body
              {
                "id": id,
                "node_id": 'MDEzOlByb2plY3RDb2x1bW4zNjc=',
                "name": name,
                "url": 'https://api.github.com/projects/columns/367',
                "project_url": 'https://api.github.com/projects/120',
                "cards_url": 'https://api.github.com/projects/columns/367/cards',
                "created_at": '2016-09-05T14:18:44Z',
                "updated_at": '2016-09-05T14:22:28Z'
              }.to_json
            end
          end
        end
      end
    end
  end
end
