# Graph findEdges benchmarks

    uuid  = require 'uuid/v1'

    Graph = require '../..'

    edges100 = for [1..100] then [ uuid(), uuid(), uuid() ]
    edges1k  = for [1..1000] then [ uuid(), uuid(), uuid() ]
    edges10k = for [1..10000] then [ uuid(), uuid(), uuid() ]

    graph100 = new Graph
    graph1k  = new Graph
    graph10k = new Graph

    graph100.setEdge edges100...
    graph1k.setEdge edges1k...
    graph10k.setEdge edges10k...

    first100 = edges100[0]
    first1k  = edges1k[0]
    first10k = edges10k[0]

    mid100   = edges100[Math.floor edges100.length / 2]
    mid1k    = edges1k[Math.floor edges1k.length / 2]
    mid10k   = edges10k[Math.floor edges10k.length / 2]

    last100  = edges100[edges100.length - 1]
    last1k   = edges1k[edges1k.length - 1]
    last10k  = edges10k[edges10k.length - 1]

    module.exports = {

      name: 'Graph findEdges (10k)'

      maxTime: 1

      tests: [

        {
          name: 'first (100)',
          fn: -> graph100.findEdges first100
        }

        {
          name: 'first (1k)',
          fn: -> graph1k.findEdges first1k
        }

        {
          name: 'first (10k)',
          fn: -> graph10k.findEdges first10k
        }

        {
          name: 'mid (100)',
          fn: -> graph100.findEdges mid100
        }

        {
          name: 'mid (1k)',
          fn: -> graph1k.findEdges mid1k
        }

        {
          name: 'mid (10k)',
          fn: -> graph10k.findEdges mid10k
        }

        {
          name: 'last (100)',
          fn: -> graph100.findEdges last100
        }

        {
          name: 'last (1k)',
          fn: -> graph1k.findEdges last1k
        }

        {
          name: 'last (10k)',
          fn: -> graph10k.findEdges last10k
        }
      ]

    }

