# frozen_string_literal: true

module GraphQL
  class GraphiQL
    class Config
      attr_accessor :graphql_path, :graphql_endpoint, :headers,
                    :title, :logo_text, :is_headers_editor_enabled,
                    :default_query, :load_from_cdn
                    # TODO: CSRF, ActionCable

      DEFAULT_HEADERS = {
        'Content-Type' => 'application/json',
      }

      def initialize
        @is_headers_editor_enabled = false
        @load_from_cdn = false
        @title = "GraphiQL"
        @headers = DEFAULT_HEADERS
      end

      def graphql_path=(path)
        raise "Cannot set `graphql_path`, as `graphql_endpoint` is already set." if graphql_endpoint
        @graphql_path = path
      end

      def graphql_endpoint=(endpoint)
        raise "Cannot set `graphql_endpoint`, as `graphql_path` is already set." if graphql_path
        @graphql_endpoint = endpoint
      end

      def merge!(config)
        config.each do |name, val|
          self.instance_variable_set("@#{name}", val)
        end
      end
    end
  end
end
