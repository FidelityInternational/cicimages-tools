module Github
  module Api
    module Mocks
      module Issue
        class CreateResponse
          extend Mirage::Template::Model
          endpoint '/repos/*/*/issues'
          content_type 'application/json'
          http_method :post
          status 201

          attr_reader :id

          def initialize
            super
            @id = rand(999_999)
          end

          def title(title = nil)
            return title unless title

            title = title
            @required_body_content << %("title":"#{title}")
          end

          def body
            {
              "id": id,
              "node_id": 'MDU6SXNzdWUx',
              "url": 'https://api.github.com/repos/octocat/Hello-World/issues/1347',
              "repository_url": 'https://api.github.com/repos/octocat/Hello-World',
              "labels_url": 'https://api.github.com/repos/octocat/Hello-World/issues/1347/labels{/name}',
              "comments_url": 'https://api.github.com/repos/octocat/Hello-World/issues/1347/comments',
              "events_url": 'https://api.github.com/repos/octocat/Hello-World/issues/1347/events',
              "html_url": 'https://github.com/octocat/Hello-World/issues/1347',
              "number": 1347,
              "state": 'open',
              "title": title,
              "body": "I'm having a problem with this.",
              "user": {
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
              "labels": [
                {
                  "id": 208_045_946,
                  "node_id": 'MDU6TGFiZWwyMDgwNDU5NDY=',
                  "url": 'https://api.github.com/repos/octocat/Hello-World/labels/bug',
                  "name": 'bug',
                  "description": 'Houston, we have a problem',
                  "color": 'f29513',
                  "default": true
                }
              ],
              "assignee": {
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
              "assignees": [
                {
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
                }
              ],
              "milestone": {
                "url": 'https://api.github.com/repos/octocat/Hello-World/milestones/1',
                "html_url": 'https://github.com/octocat/Hello-World/milestones/v1.0',
                "labels_url": 'https://api.github.com/repos/octocat/Hello-World/milestones/1/labels',
                "id": 1_002_604,
                "node_id": 'MDk6TWlsZXN0b25lMTAwMjYwNA==',
                "number": 1,
                "state": 'open',
                "title": 'v1.0',
                "description": 'Tracking milestone for version 1.0',
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
                "open_issues": 4,
                "closed_issues": 8,
                "created_at": '2011-04-10T20:09:31Z',
                "updated_at": '2014-03-03T18:58:10Z',
                "closed_at": '2013-02-12T13:22:01Z',
                "due_on": '2012-10-09T23:39:01Z'
              },
              "locked": true,
              "active_lock_reason": 'too heated',
              "comments": 0,
              "pull_request": {
                "url": 'https://api.github.com/repos/octocat/Hello-World/pulls/1347',
                "html_url": 'https://github.com/octocat/Hello-World/pull/1347',
                "diff_url": 'https://github.com/octocat/Hello-World/pull/1347.diff',
                "patch_url": 'https://github.com/octocat/Hello-World/pull/1347.patch'
              },
              "closed_at": nil,
              "created_at": '2011-04-22T13:33:48Z',
              "updated_at": '2011-04-22T13:33:48Z',
              "closed_by": {
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
              }
            }.to_json
          end
        end
      end

      module Project
        class CreateCardMockResoponse
          extend Mirage::Template::Model
          endpoint '/projects/*/*/cards'
          content_type 'application/json'
          http_method :post

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
        class CreateColumnMockResponse
          extend Mirage::Template::Model

          endpoint '/projects/*/columns'
          content_type 'application/json'
          http_method :post

          attr_reader :name, :id

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
        class CreateMockResponse
          extend Mirage::Template::Model

          endpoint '/repos/*/*/projects'
          content_type 'application/json'
          http_method :post

          attr_reader :project_id

          def initialize
            super
            @project_id = rand(999_999)
          end

          def body
            {
              "owner_url": 'https://api.github.com/repos/api-playground/projects-test',
              "url": 'https://api.github.com/projects/1002604',
              "html_url": 'https://github.com/api-playground/projects-test/projects/12',
              "columns_url": 'https://api.github.com/projects/1002604/columns',
              "id": project_id,
              "node_id": 'MDc6UHJvamVjdDEwMDI2MDQ=',
              "name": 'Projects Documentation',
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
