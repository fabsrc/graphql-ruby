const container = document.getElementById("graphiql");

const graphqlEndpoint = container.dataset.graphqlEndpoint;
const headers = JSON.parse(container.dataset.headers);
const isHeadersEditorEnabled =
  container.dataset.isHeadersEditorEnabled !== "false";
const defaultQuery = container.dataset.defaultQuery;
const logoText = container.dataset.logoText;

function fetcher(graphQLParams, fetcherOpts) {
    return fetch(graphqlEndpoint, {
        method: "POST",
        body: JSON.stringify(graphQLParams),
        headers: {
            ...headers,
            ...fetcherOpts.headers,
        },
    }).then((res) => res.json());
    // TODO: Add fetchers for subscriptions
}

ReactDOM.render(
  React.createElement(
    GraphiQL,
    {
      fetcher,
      isHeadersEditorEnabled,
      defaultQuery,
    },
    React.createElement(GraphiQL.Logo, {}, logoText)
  ),
  container
);
