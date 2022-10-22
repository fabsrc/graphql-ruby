# frozen_string_literal: true

require "erb"

module GraphQL
  class GraphiQLApplication
    CSP_HEADER = [
      "default-src 'self' https: http:",
      "child-src 'self'",
      "connect-src 'self' https: http: wss: ws:",
      "font-src 'self' https: http: data:",
      "frame-src 'self'",
      "img-src 'self' https: http: data:",
      "manifest-src 'self'",
      "media-src 'self'",
      "object-src 'none'",
      "script-src 'self' https: http: 'unsafe-inline' 'unsafe-eval'",
      "style-src 'self' https: http: 'unsafe-inline'",
      "worker-src 'self'",
      "base-uri 'self'"
    ].join("; ").freeze

    def initialize(config)
      @config = config
    end

    def graphql_endpoint
      if @config.graphql_path
        File.join(@env["ORIGINAL_SCRIPT_NAME"] || "", @config.graphql_path)
      elsif @config.graphql_endpoint
        @config.graphql_endpoint
      else
        raise("No `graphql_path` or `graphql_endpoint` defined!")
      end
    end

    def root_path
      @root_path ||= @env["SCRIPT_NAME"]
    end

    def erb(template)
      path = File.expand_path("#{GraphQL::GraphiQL::ROOT}/views/#{template}")
      ERB.new(File.read(path)).result(binding)
    end

    def call(env)
      @env ||= env

      [
        200,
        {
          "content-type" => "text/html",
          "cache-control" => "private, no-store",
          "content-security-policy" => CSP_HEADER
        },
        [erb("index.html.erb")]
      ]
    end
  end
end
