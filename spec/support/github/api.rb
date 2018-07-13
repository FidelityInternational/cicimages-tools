module Github
  module Api
    def self.mock(mirage)
      require_relative 'api/mocks'

      Projects.mock(mirage)
      Issues.mock(mirage)
      Repos.mock(mirage)
    end

    module Projects
      def self.mock(mirage)
        mirage.put(Mocks::Project::CreateResponse.new)
        mirage.put(Mocks::Project::Column::CreateResponse.new) do
          default true
        end
        mirage.put(Mocks::Project::Card::CreateResponse.new)
      end
    end

    module Issues
      def self.mock(mirage)
        mirage.put(Mocks::Issue::CreateResponse.new)
      end
    end

    module Repos
      def self.mock(mirage)
        mirage.put(Mocks::Repos::GetResponse.new)
      end
    end
  end
end
