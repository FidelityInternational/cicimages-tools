module Github
  module Api
    module Mocks
      module Project
        class CreateResponse
          extend Mirage::Template::Model
          extend Mirage::Template::JSONRequirements

          endpoint '/repos/*/*/projects'
          content_type 'application/json'
          http_method :post

          json_requirement :name

          attr_reader :project_id, :html_url

          def initialize(project_id: rand(999_999))
            super
            @project_id = project_id
            @html_url = 'https://github.com/api-playground/projects-test/projects/12'
          end

          def body
            {
              "owner_url": 'https://api.github.com/repos/api-playground/projects-test',
              "url": 'https://api.github.com/projects/1002604',
              "html_url": html_url,
              "columns_url": 'https://api.github.com/projects/1002604/columns',
              "id": project_id,
              "node_id": 'MDc6UHJvamVjdDEwMDI2MDQ=',
              "name": name,
              "body": 'Developer documentation project for the developer site.',
              "number": 1,
              "state": 'open',
              "creator": {
                "login": 'octocat',
                "id": 1,
                "node_id": 'MDQ6VXNlcjE=',
                "avatar_url": 'https://github.com/images/error/octocat_happy.gif',
                "gravatar_id": '',
                "url": 'https://api.github.com/users/octocat',
                "html_url": 'https://github.com/octocat',
                "followers_url": 'https://api.github.com/users/octocat/followers',
                "following_url": 'https://api.github.com/users/octocat/following{/other_user}',
                "gists_url": 'https://api.github.com/users/octocat/gists{/gist_id}',
                "starred_url": 'https://api.github.com/users/octocat/starred{/owner}{/repo}',
                "subscriptions_url": 'https://api.github.com/users/octocat/subscriptions',
                "organizations_url": 'https://api.github.com/users/octocat/orgs',
                "repos_url": 'https://api.github.com/users/octocat/repos',
                "events_url": 'https://api.github.com/users/octocat/events{/privacy}',
                "received_events_url": 'https://api.github.com/users/octocat/received_events',
                "type": 'User',
                "site_admin": false
              },
              "created_at": '2011-04-10T20:09:31Z',
              "updated_at": '2014-03-03T18:58:10Z'
            }.to_json
          end
        end
      end
    end
  end
end
