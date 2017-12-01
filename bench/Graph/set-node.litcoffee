# Graph setNode benchmarks

    uuid  = require 'uuid/v1'

    Graph = require '../..'

    nodes100 = for [1..100] then uuid()
    nodes1k  = for [1..1000] then uuid()
    nodes10k = for [1..10000] then uuid()

    graph100 = new Graph
    graph1k  = new Graph
    graph10k = new Graph

    module.exports = {

      name: 'Graph setNode'

      tests: [

        {
          name: 'setNode (100)'

          maxTime: 1

          fn: ->
            graph100.nodes = []
            graph100.setNode nodes100...
        }

        {
          name: 'setNode (1k)'

          fn: ->
            graph1k.nodes = []
            graph1k.setNode nodes1k...
        }

        {
          name: 'setNode (10k)'

          fn: ->
            graph10k.nodes = []
            graph10k.setNode nodes10k...
        }

      ]

    }
