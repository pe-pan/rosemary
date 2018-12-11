namespace: microfocus.te.rosemary.util
flow:
  name: json_to_list
  inputs:
    - json
    - property
  workflow:
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$[*].'+property}"
        publish:
          - list: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - list: '${list}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      json_path_query:
        x: 149
        y: 125
        navigate:
          217b0ed1-26df-9ed5-9b64-57f51583e5c9:
            targetId: b7810c88-5f00-affd-11c5-333d65ec4465
            port: SUCCESS
    results:
      SUCCESS:
        b7810c88-5f00-affd-11c5-333d65ec4465:
          x: 266
          y: 122
