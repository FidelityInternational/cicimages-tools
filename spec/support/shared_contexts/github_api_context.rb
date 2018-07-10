require 'mirage/client'
require 'mirage/template/json_requirements'
require 'github/api'
require 'github/api/mocks'
require_relative 'github_api_context/mirage_request_matcher'

module GithubApiExpectations
  API_METHODS = { project_api: Github::Api::Mocks::Project::CreateResponse,
                  project_column_api: Github::Api::Mocks::Project::Column::CreateResponse,
                  issue_api: Github::Api::Mocks::Issue::CreateResponse,
                  project_card_api: Github::Api::Mocks::Project::Card::CreateResponse }.freeze

  API_METHODS.each do |api_method, mock_response_class|
    define_method api_method do
      @expectation_chain = MirageRequestMatcher.new(self, mirage, mock_response_class, api_method)
    end
  end

  def to_be_called_with(attribute_hash)
    @expectation_chain.expects(attribute_hash)
  end

  def with_uri(uri)
    @expectation_chain.with_uri(uri)
  end
end

shared_context :github_api do
  include GithubApiExpectations

  MIRAGE_CLIENT = Mirage.start

  def mirage
    MIRAGE_CLIENT
  end

  before(:each) do |*_args|
    mirage.clear
    Github::Api.mock(mirage)
  end

  after(:each) do |example|
    after_actions.each(&:validate) unless example.exception
  end

  let(:after_actions) do
    @after_actions ||= []
  end
end
