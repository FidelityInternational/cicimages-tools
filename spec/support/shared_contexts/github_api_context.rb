require 'mirage/client'
require 'mirage/template/json_requirements'
require 'mirage/rspec/expectations'
require 'github/api'
require 'github/api/mocks'
require_relative 'github_api_context/mirage_request_matcher'

shared_context :github_api do
  include_context :mirage

  before(:each) do |*_args|
    mirage.clear
    template_finders = Github::Api.mock(mirage)

    template_finders.each { |api, fixture| define_expectation_method(api, fixture) }
    template_finders.each { |api, fixture| define_requests_method(api, fixture) }
  end
end
