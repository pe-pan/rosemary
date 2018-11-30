namespace: microfocus.te.rosemary.options.util
flow:
  name: get_id
  inputs:
    - json_object
    - name
  workflow:
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_object}'
            - json_path: "${'$[?(@.name==\\''+name+'\\')].morValue'}"
        publish:
          - id: '${return_result[2:len(return_result)-2]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - id: '${id}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      json_path_query:
        x: 41
        y: 83
        navigate:
          e2710fe8-8150-a1ae-b3c1-3004087042b3:
            targetId: eb3b2743-a91e-0a0c-6e0d-edeb4c3d1231
            port: SUCCESS
    results:
      SUCCESS:
        eb3b2743-a91e-0a0c-6e0d-edeb4c3d1231:
          x: 188
          y: 88
