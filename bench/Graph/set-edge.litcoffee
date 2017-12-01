# Graph setEdge benchmarks

    uuid  = require 'uuid/v1'

    Graph = require '../..'

    edges100 = for [1..100] then [ uuid(), uuid(), uuid() ]
    edges1k  = for [1..1000] then [ uuid(), uuid(), uuid() ]
    edges10k = for [1..10000] then [ uuid(), uuid(), uuid() ]

    graph100 = new Graph
    graph1k  = new Graph
    graph10k = new Graph

    module.exports = {

      name: 'Graph setEdge'

      tests: [

        {
          name: 'setEdge (100)'

          maxTime: 1

          fn: ->
            graph100.nodes = []
            graph100.edges = []
            graph100.setEdge edges100...
        }

        {
          name: 'setEdge (1k)'

          fn: ->
            graph1k.nodes = []
            graph1k.edges = []
            graph1k.setEdge edges1k...
        }

        {
          name: 'setEdge (10k)'

          fn: ->
            graph10k.nodes = []
            graph10k.edges = []
            graph10k.setEdge edges10k...
        }

      ]

    }
