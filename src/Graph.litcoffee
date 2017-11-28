# Graph

This class manages graph topology. Actual data should be managed elsewhere.

## Instance properties

* `graph.id` - graph *UUID*
* `graph.nodes` is a list of *UUIDs*
* `graph.edges` is a list of arrays of form: `[ fromNodeUUID, toNodeUUID, edgeUUID ]`

## Events

* `set`
* `unset`

## Imports

    uuid = require 'uuid/v1'

    { EventEmitter } = require 'events'

## Graph Class

    class Graph extends EventEmitter

### Clone Edges Helper

      @cloneEdges = (edges) ->

        return unless edges

        edges.map (edge) -> [edge...]

### Sanitize edges helper

      @sanitizeEdges = (edges) ->

        return unless edges

        edges = edges

> Filter out junk

          .filter (e) -> (Array.isArray e) and e[0] and e[1]

> Generate `edge` `id` if missing

          .map ([f, t, i]) -> [f, t, i or uuid()]

> Remove duplicates

        edges.filter (edge) -> edge is edges.find ([f, t, i]) ->
          (f is edge[0]) and (t is edge[1]) and (i is edge[2])

### Constructor

      constructor: (options = {}) ->

        super()

        @id = options.id or uuid()

        @nodes = unless options.nodes then [] else [options.nodes...]
        @edges = Graph.sanitizeEdges options.edges or []

### Find Edge(s)

      findEdges: (queries...) ->

        queries = queries.filter (i) -> i

        Graph.sanitizeEdges [].concat.apply [], queries.map (query) =>

> Find by edge UUID

          if typeof query is 'string'
            return [
              @edges.find ([f, t, i]) -> i is query
            ]

> Find exact edge

          if query[0] and query[1] and query[2]
            return [
              @edges.find ([f, t, i]) ->
                (f is query[0]) and (t is query[1]) and (i is query[2])
            ]

> Find by `from` and `to` UUIDs

          @edges.filter ([f, t]) -> (f is query[0]) and (t is query[1])

### Set Graph Node(s)

      setNode: (nodes...) ->

> Only new nodes

        nodes = nodes.filter (node) => not @nodes.includes node

        if nodes.length > 0

          event = { graph: @, nodes }

          @emit 'set', event

        if nodes.length > 0
          @nodes = [@nodes..., nodes...]

        @

### Unset Graph Node(s)

      unsetNode: (nodes...) ->

> Only existing nodes

        nodes = nodes.filter (node) => @nodes.includes node

        if nodes.length > 0

> Related edges

          edges = Graph.cloneEdges @edges.filter ([f, t, i]) ->
            (nodes.includes f) or (nodes.includes t)

          event = { graph: @, nodes }

          if edges.length > 0
            event.edges = edges

          @emit 'unset', event

> Remove nodes

        if nodes.length > 0
          @nodes = @nodes.filter (node) -> not nodes.includes node

> Remove edges

        if edges?.length > 0
          @edges = @edges.filter ([f, t, i]) ->
            not edges.find (e) -> (e[0] is f) and (e[1] is t) and (e[2] is i)

        @

### Set Graph Edge(s)

      setEdge: (edges...) ->

> Only changed or new edges

        edges = (Graph.sanitizeEdges edges).filter (edge) =>

          not @edges.find ([f, t, i]) ->
            (edge[0] is f) and (edge[1] is t) and (edge[2] is i)

        if edges.length > 0

> Related nodes

          nodes = [].concat.apply [], edges.map ([f, t]) -> [f, t]

          nodes = nodes.filter (node, i) =>
            (i is nodes.indexOf node) and not @nodes.includes node

          event = { graph: @, edges }

          if nodes.length > 0
            event.nodes = nodes

          @emit 'set', event

> Add related missing nodes

        if nodes?.length > 0
          @nodes = [@nodes..., nodes...]

        if edges.length > 0

> Remove old edges

          _edges = @edges.filter (edge) ->
            not edges.find ([f, t, i]) -> edge[2] is i

          @edges = [_edges..., edges...]

        @

### Unset Graph Edge(s)

      unsetEdge: (edges...) ->

        edges = @findEdges edges...

        if edges.length > 0

          event = { graph: @, edges }

          @emit 'unset', event

> Remove edges

        if edges.length > 0
          @edges = @edges.filter (edge) -> not edges.find ([f, t, i]) ->
            (edge[0] is f) and (edge[1] is t) and (edge[2] is i)

        @

### JSON.stringify

      toJSON: -> JSON.parse JSON.stringify { @id, @nodes, @edges }

## Exports

    module.exports = Graph