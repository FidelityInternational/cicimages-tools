require 'mirage/client'
require 'mirage/template/json_requirements'
require 'mirage/rspec/expectations'
require 'github/api'
require 'github/api/mocks'
require_relative 'github_api_context/mirage_request_matcher'

shared_context :github_api do
  include_context :mirage

  API_METHODS = { project: Github::Api::Mocks::Project::CreateResponse,
                  project_column: Github::Api::Mocks::Project::Column::CreateResponse,
                  issue: Github::Api::Mocks::Issue::CreateResponse,
                  project_card: Github::Api::Mocks::Project::Card::CreateResponse,
                  repos: Github::Api::Mocks::Repos::GetResponse }.freeze

  API_METHODS.each { |api, mock_response_class| define_api_method(api, mock_response_class) }

  before(:each) do |*_args|
    mirage.clear
    Github::Api.mock(mirage)
  end
end
