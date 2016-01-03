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
      },
      {
          type:        :function,
          name:        :json_object_key_at_index,
          description: "Returns the string value of the key in a json object at a specified index, or null if the index is out of range",
          params:      "j varchar(max), i int",
          return_type: "varchar(max)",
          body:        %~
            import json
            if not j:
              return None
            try:
              dict = json.loads(j)
            except ValueError:
              return None
            if len(dict.keys()) - 1 < i:
                return None
            return dict.keys()[i]
          ~,
          tests:       [
                           {query: "select ?('{\"foo\" : \"bar\"}',0)", expect: "foo", example: true},
                           {query: "select ?('{\"foo\" : \"bar\", \"baz\" : 1}' ,1)", expect: "baz", example: true},
                           {query: "select ?('{\"foo\" : \"bar\"}', 1)", expect: nil, example: true},
                           {query: "select ?('{}', 0)", expect: nil, example: true},
                           {query: "select ?('',0)", expect: nil},
                           {query: "select ?(null,0)", expect: nil},
                           {query: "select ?('abc',0)", expect: nil},
                       ]
      },
      {
          type:        :function,
          name:        :json_object_value_at_key,
          description: "Returns the string value of in a json object at a specified key, or null if the index is out of range",
          params:      "j varchar(max), i int",
          return_type: "varchar(max)",
          body:        %~
            import json
            if not j:
              return None
            try:
              dict = json.loads(j)
            except ValueError:
              return None
            if len(dict.keys()) - 1 < i:
                return None
            return dict.keys()[i]
          ~,
          tests:       [
                           {query: "select ?('{\"foo\" : \"bar\"}',0)", expect: "foo", example: true},
                           {query: "select ?('{\"foo\" : \"bar\", \"baz\" : 1}' ,1)", expect: "baz", example: true},
                           {query: "select ?('{\"foo\" : \"bar\"}', 1)", expect: nil, example: true},
                           {query: "select ?('{}', 0)", expect: nil, example: true},
                           {query: "select ?('',0)", expect: nil},
                           {query: "select ?(null,0)", expect: nil},
                           {query: "select ?('abc',0)", expect: nil},
                       ]
      }
  ]
end
