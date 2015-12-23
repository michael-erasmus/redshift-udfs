class UdfJsonObjects
  UDFS = [
      {
          type:        :function,
          name:        :json_object_key_count,
          description: "Returns the number of keys in a json object",
          params:      "j varchar(max)",
          return_type: "int",
          body:        %~
            import json
            if not j:
              return None
            try:
              dict = json.loads(j)
            except ValueError:
              return None
            return len(dict.keys())
          ~,
          tests:       [
                           {query: "select ?('{\"foo\" : \"bar\"}')", expect: 1, example: true},
                           {query: "select ?('{\"foo\" : \"bar\", \"baz\" : 1}')", expect: 2, example: true},
                           {query: "select ?('{}')", expect: 0, example: true},
                           {query: "select ?('')", expect: nil},
                           {query: "select ?(null)", expect: nil},
                           {query: "select ?('abc')", expect: nil},
                       ]
      }
  ]
end
