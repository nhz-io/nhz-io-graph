# Graph Constructor benchmark

    Graph = require '../..'

    module.exports = {

      name: 'Graph constructor'

      maxTime: 1

      tests: [

        {
          name: 'Without options'

          fn: -> new Graph
        }

        {
          name: 'With id'

          fn: -> new Graph { id: 'fake uuid' }
        }

      ]

    }