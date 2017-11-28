# Graph

[![Travis Build][travis]](https://travis-ci.org/nhz-io/nhz-io-graph)
[![Coverage][coveralls]](https://coveralls.io/github/nhz-io/nhz-io-graph)
[![NPM Version][npm]](https://www.npmjs.com/package/@nhz.io/graph)

## Install

```bash
npm i -S @nhz.io/graph
```

## Usage

This:

```js
const Graph = require('@nhz.io/graph')

const graph = new Graph()

graph.setEdge ['node-1', 'node-2', 'edge-1']
graph.setEdge ['node-1', 'node-3', 'edge-2']

console.log(JSON.stringify(graph, null, 2))
```

Will produce:
```json
{
  "id": "737e19e0-d447-11e7-901a-c91a9d397e30",
  "nodes": [
    "node-1",
    "node-2",
    "node-3"
  ],
  "edges": [
    [
      "node-1",
      "node-2",
      "edge-1"
    ],
    [
      "node-1",
      "node-3",
      "edge-2"
    ]
  ]
}
```

## Version 0.1.0

## License [MIT](LICENSE)

[travis]: https://img.shields.io/travis/nhz-io/nhz-io-graph.svg?style=flat
[npm]: https://img.shields.io/npm/v/@nhz.io/graph.svg?style=flat
[coveralls]: https://coveralls.io/repos/github/nhz-io/nhz-io-graph/badge.svg?branch=v0.1.0