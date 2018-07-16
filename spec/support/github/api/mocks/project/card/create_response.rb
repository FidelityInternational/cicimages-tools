# module JSONRequirements
#   def json_requirement name
#     define_method name do |value=nil|
#       variable_name = :"@#{name}"
#       return instance_variable_get(variable_name) unless value
#       instance_variable_set(variable_name, value)
#       required_body_content << %Q{"#{name}":#{value.to_json}}
#     end
#   end
# end

module Github
  module Api
    module Mocks
      module Project
        module Card
          class CreateResponse
            extend Mirage::Template::Model
            extend Mirage::Template::JSONRequirements

            endpoint '/projects/*/*/cards'
            content_type 'application/json'
            http_method :post

            json_requirement :content_id

            def body
              {
                "url": 'https://api.github.com/projects/columns/cards/1478',
                "column_url": 'https://api.github.com/projects/columns/367',
                "content_url": 'https://api.github.com/repos/api-playground/projects-test/issues/3',
                "id": 1478,
                "node_id": 'MDExOlByb2plY3RDYXJkMTQ3OA==',
                "note": 'Add payload for delete Project column',
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
                "created_at": '2016-09-05T14:21:06Z',
                "updated_at": '2016-09-05T14:20:22Z',
                "archived": false
              }.to_json
            end
          end
        end
      end
    end
  end
end
