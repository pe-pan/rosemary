namespace: microfocus.te.rosemary.util
flow:
  name: get_children
  inputs:
    - json_object
    - parent_id
    - parent_type
  workflow:
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_object}'
            - json_path: "${'$[?(@.parent==\\'{_value:'+parent_id+',val:'+parent_id+',type:'+parent_type+'}\\')][\\'morValue\\',\\'name\\']'}"
        publish:
          - children: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - children: '${children}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      json_path_query:
        x: 52
        y: 83
        navigate:
          3e2016e8-b6dd-47b2-fc6c-048b2252e488:
            targetId: 3e3e97c7-6650-6b1e-0664-3357af32125f
            port: SUCCESS
    results:
      SUCCESS:
        3e3e97c7-6650-6b1e-0664-3357af32125f:
          x: 247
          y: 85
