# frozen_string_literal: true

require "rack/builder"
require "rack/static"

require "graphql/graphiql/config"
require "graphql/graphiql/application"

module GraphQL
  class GraphiQL
    ROOT = File.expand_path("#{File.dirname(__FILE__)}/../../graphiql")

    class << self
      def config
        @config ||= Config.new
      end

      def call(env)
        @instance ||= new
        @instance.call(env)
      end
    end

    def initialize(**config)
      @config ||= self.class.config.dup
      @config.merge!(config)
    end

    def call(env)
      app.call(env)
    end

    private

    def app
      @app ||= build
    end

    def build
      graphiql_application = GraphiQLApplication.new(@config)

      Rack::Builder.new do
        use Rack::Static, root: ROOT, urls: ["/assets/stylesheets", "/assets/javascripts"]
        run graphiql_application
      end
    end
  end
end
