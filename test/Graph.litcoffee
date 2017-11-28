# Graph Tests

    { EventEmitter } = require 'events'

    Graph = require '../src/Graph'

    describe 'Graph', ->

      it 'should be a subclass of EventEmitter', ->
        EventEmitter.prototype.isPrototypeOf(Graph.prototype).should.be.true

      describe 'cloneEdges()', ->

        it 'should do nothing without args', ->
          expect(Graph.cloneEdges()).to.be.equal undefined

        it 'should deep clone edges', ->

          a = ['a', 'b', 'c']
          b = ['d', 'e', 'f']

          edges = Graph.cloneEdges [a, b]

          expect(edges).to.deep.equal [a, b]

          expect(edges[0]).not.to.be.equal a
          expect(edges[0]).to.be.deep.equal a

          expect(edges[1]).not.to.be.equal b
          expect(edges[1]).to.be.deep.equal b

      describe 'sanitizeEdges()', ->

        it 'should do nothing without args', ->
          expect(Graph.sanitizeEdges()).to.be.equal undefined

        it 'should filter out junk', ->

          edges = Graph.sanitizeEdges [
            ['a'], [], ['a', 'b'], ['a', 'b', 'c'], 'junk', null, undefined, 1
          ]

          expect(edges.length).to.be.equal 2

        it 'should generate edge UUID if missing', ->

          edges = Graph.sanitizeEdges [ ['a'], ['a', 'b'], ['a', 'b', 'c'] ]

          expect(edges.length).to.be.equal 2

          expect(edges[0][0]).to.be.equal 'a'
          expect(edges[0][1]).to.be.equal 'b'
          expect(edges[0][2]).to.be.ok

          expect(edges[1]).to.be.deep.equal ['a', 'b', 'c']

        it 'should remove duplicates', ->

          edges = Graph.sanitizeEdges [ ['a'], ['a', 'b', 'c'], ['a', 'b', 'c'] ]

          expect(edges.length).to.be.equal 1

          expect(edges).to.be.deep.equal [ ['a', 'b', 'c'] ]

      describe 'constructor()', ->

        it 'should create an instance of Graph with defaults', ->

          graph = new Graph

          expect(graph.id).to.be.ok
          expect(graph.nodes.length).to.be.equal 0
          expect(graph.edges.length).to.be.equal 0

        it 'should create an instance using supplied options', ->

          nodes = ['a', 'b']
          edges = [ ['a', 'b', 'c'] ]

          graph = new Graph { id: 'test', nodes, edges }

          expect(graph.id).to.be.equal 'test'

          expect(graph.nodes).not.to.be.equal nodes
          expect(graph.nodes).to.be.deep.equal nodes

          expect(graph.edges).not.to.be.equal edges
          expect(graph.edges).to.be.deep.equal edges

      describe '#findEdges()', ->

        it 'should find edges by `uuid` string', ->

          edges = [ ['a', 'b', 'UUID1'], ['c', 'd', 'UUID2'] ]

          graph = new Graph { edges }

          expect(graph.findEdges edges[0][2]).to.be.deep.equal [ edges[0] ]
          expect(graph.findEdges edges[1][2]).to.be.deep.equal [ edges[1] ]

        it 'should find edges by `from` and `to` nodes', ->

          edges = [ ['a', 'b', 'UUID1'], ['a', 'b', 'UUID2'], ['c', 'd', 'UUID3'] ]

          graph = new Graph { edges }

          expect(graph.findEdges ['a', 'b']).to.be.deep.equal [ edges[0], edges[1] ]

          expect(graph.findEdges ['c', 'd']).to.be.deep.equal [ edges[2] ]

        it 'should find exact edges', ->

          edges = [ ['a', 'b', 'UUID1'], ['a', 'b', 'UUID2'], ['c', 'd', 'UUID3'] ]

          graph = new Graph { edges }

          expect(graph.findEdges edges[0], edges[1]).to.be.deep.equal [ edges[0], edges[1] ]

      describe '#setNode()', ->

        it 'should set new nodes', ->

          graph = new Graph { nodes: ['a', 'b'] }

          graph.setNode 'a', 'b', 'c', 'a', 'd'

          expect(graph.nodes).to.be.deep.equal ['a', 'b', 'c', 'd']

        it 'should emit `set` with filtered nodes', (done) ->

          nodes = ['a', 'b']

          graph = new Graph { nodes }

          graph.once 'set', (event) =>

            expect(event.graph).to.be.equal graph
            expect(event.nodes).to.be.deep.equal ['c', 'd']

            done()

          graph.setNode nodes..., 'c', 'd'


      describe '#unsetNode()', ->

        it 'should unset existing nodes', ->

          graph = new Graph { nodes: ['a', 'b', 'c'] }

          graph.unsetNode 'k', 'l'

          graph.unsetNode 'a', 'd', 'e'

          expect(graph.nodes).to.be.deep.equal ['b', 'c']

        it 'should unset related edges', ->

          nodes = ['a', 'b', 'c']
          edges = [ ['a', 'b', 'd'], ['b', 'c', 'e'], ['a', 'c', 'f'] ]

          graph = new Graph { nodes, edges }
          graph.unsetNode 'a'
          expect(graph.nodes).to.be.deep.equal ['b', 'c']
          expect(graph.edges).to.be.deep.equal [ edges[1] ]

          graph = new Graph { nodes, edges }
          graph.unsetNode 'b'
          expect(graph.nodes).to.be.deep.equal ['a', 'c']
          expect(graph.edges).to.be.deep.equal [ edges[2] ]

          graph = new Graph { nodes, edges }
          graph.unsetNode 'c'
          expect(graph.nodes).to.be.deep.equal ['a', 'b']
          expect(graph.edges).to.be.deep.equal [ edges[0] ]

        it 'should emit `unset` with filtered nodes', (done) ->

          graph = new Graph { nodes: ['a', 'b', 'c'] }

          graph.once 'unset', (event) ->

            expect(event.nodes).to.be.deep.equal ['a', 'b']

            done()

          graph.unsetNode 'a', 'd', 'e', 'b'

        it 'should emit `unset` with related edges', (done) ->

          edges = [ ['a', 'b', 'd'], ['b', 'c', 'e'], ['a', 'c', 'f'] ]

          graph = new Graph { nodes: ['a', 'b', 'c'], edges }

          graph.once 'unset', (event) ->

            expect(event.nodes).to.be.deep.equal ['a', 'b']
            expect(event.edges).to.be.deep.equal edges

            done()

          graph.unsetNode 'a', 'd', 'e', 'b'

      describe '#setEdge()', ->
        it 'should do nothing for empty args', -> (new Graph).setEdge()

        it 'should set changed or new edges', ->

          edges = [ ['a', 'b', 'k'], ['b', 'c', 'l'] ]

          graph = new Graph { edges }

          newEdges = [ ['c', 'd', 'k'], ['a', 'b', 'm'] ]

          graph.setEdge newEdges...

          expect(graph.edges).to.be.deep.equal [ edges[1], newEdges... ]

        it 'should add missing nodes', ->

          graph = new Graph

          graph.setEdge ['c', 'd', 'k'], ['c', 'e', 'm'], ['a', 'b', 'n']

          expect(graph.nodes).to.be.deep.equal [ 'c', 'd', 'e', 'a', 'b' ]

        it 'should emit `set` with sanitized edges', (done) ->

          edges = [ ['a', 'b', 'k'], ['b', 'c', 'l'] ]
          newEdges = [ ['a', 'b', 'k'], ['c', 'd', 'k'], ['a', 'b', 'm'] ]

          graph = new Graph { edges }

          graph.once 'set', (event) ->

            expect(event.edges).to.be.deep.equal newEdges.slice(1)

            done()

          graph.setEdge newEdges...

          expect(graph.edges).to.be.deep.equal [ edges[1], newEdges.slice(1)... ]

        it 'should emit `set` with missing nodes', (done) ->

          edges = [ ['a', 'b', 'k'], ['b', 'c', 'l'] ]
          newEdges = [ ['a', 'b', 'k'], ['c', 'd', 'k'], ['a', 'b', 'm'] ]

          newNodes = ['c', 'd', 'a', 'b']

          graph = new Graph { edges }

          graph.once 'set', (event) ->

            expect(event.nodes).to.be.deep.equal newNodes

            done()

          graph.setEdge newEdges...

          expect(graph.nodes).to.be.deep.equal newNodes

      describe '#unsetEdge()', ->

        it 'should do nothing for empty args', -> (new Graph).unsetEdge()

        it 'should remove matching edges', ->

          edges = [ ['a', 'b', 'c'], ['d', 'e', 'f'], ['g', 'h', 'i'], ['j', 'k', 'l'] ]

          graph = new Graph { edges }

          graph.unsetEdge ['a', 'b', 'c'], 'i'

          expect(graph.edges).to.be.deep.equal [ edges[1], edges[3] ]

        it 'should emit `unset` with sanitized edges', (done) ->

          edges = [ ['a', 'b', 'c'], ['d', 'e', 'f'], ['g', 'h', 'i'], ['j', 'k', 'l'] ]

          graph = new Graph { edges }

          graph.once 'unset', (event) ->

            expect(event.edges).to.be.deep.equal [ edges[0], edges[2] ]

            done()

          graph.unsetEdge ['a', 'b', 'c'], 'i', 'nothing', null, ['x', 'y', 'z']

          expect(graph.edges).to.be.deep.equal [ edges[1], edges[3] ]

      describe '#toJSON()', ->

        it 'should convert the graph into `options` object', ->

          edges = [ ['a', 'b', 'c'], ['d', 'e', 'f'], ['g', 'h', 'i'] ]
          graph = new Graph

          graph.setEdge edges...

          options = graph.toJSON()

          expect(Object.keys(options).length).to.be.equal 3
          expect(options).to.have.property 'id'

          expect(options.nodes).to.deep.equal ['a','b','d','e','g','h']

          expect(options.edges).to.deep.equal edges
