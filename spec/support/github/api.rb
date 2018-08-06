module Github
  module Api
    def self.mock(mirage)
      require_relative 'fixture'
      require_relative 'api/mocks'
      Projects.mock(mirage).merge(Issues.mock(mirage)).merge(Repos.mock(mirage))
    end

    module Projects
      def self.mock(mirage)
        { projects_api: Fixture.new(mirage: mirage,
                                    response_class: Mocks::Project::CreateResponse,
                                    request_class: Mocks::Project::CreateRequest),
          projects_columns_api: Fixture.new(mirage: mirage,
                                            response_class: Mocks::Project::Column::CreateResponse,
                                            request_class: Mocks::Project::Column::CreateRequest),
          projects_cards_api: Fixture.new(mirage: mirage,
                                          response_class: Mocks::Project::Card::CreateResponse,
                                          request_class: Mocks::Project::Card::CreateRequest) }
      end
    end

    module Issues
      def self.mock(mirage)
        {
          issues_api: Fixture.new(mirage: mirage,
                                  response_class: Mocks::Issue::CreateResponse,
                                  request_class: Mocks::Issue::CreateRequest)
        }
      end
    end

    module Repos
      def self.mock(mirage)
        {
          repos_get_api: Fixture.new(mirage: mirage,
                                     response_class: Mocks::Repos::GetResponse,
                                     request_class: Mocks::Repos::GetRequest),

          repos_edit_api: Fixture.new(mirage: mirage,
                                      response_class: Mocks::Repos::EditResponse,
                                      request_class: Mocks::Repos::EditRequest)
        }
      end
    end
  end
end
