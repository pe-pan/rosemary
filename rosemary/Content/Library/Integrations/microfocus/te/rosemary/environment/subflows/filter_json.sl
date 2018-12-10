namespace: Integrations.microfocus.te.rosemary.environment.subflows
flow:
  name: filter_json
  inputs:
    - json
    - prefix
    - filtered_json
    - vm_id
  workflow:
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${\"$[?(@.morValue == '\"+vm_id+\"')].name\"}"
        publish:
          - vm_name: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: is_true
          - FAILURE: on_failure
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: '${str(vm_name.startswith(prefix))}'
        navigate:
          - 'TRUE': add_object_into_json_array
          - 'FALSE': SUCCESS
    - add_object_into_json_array:
        do:
          io.cloudslang.base.json.add_object_into_json_array:
            - json_array: '${filtered_json}'
            - json_object: "${\"{'name':'\"+vm_name+\"','morValue':'\"+vm_id+\"'}\"}"
        publish:
          - filtered_json: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - result_json: '${filtered_json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      json_path_query:
        x: 117
        y: 117
      is_true:
        x: 321
        y: 123
        navigate:
          afd49e3c-831d-875b-d41a-255acabc1d94:
            targetId: dd7acdfb-e0b5-679f-4e21-8ae9ac25c1d9
            port: 'FALSE'
      add_object_into_json_array:
        x: 424
        y: 129
        navigate:
          31c4abf6-3cde-1c3e-1dcb-2889d58d6675:
            targetId: dd7acdfb-e0b5-679f-4e21-8ae9ac25c1d9
            port: SUCCESS
    results:
      SUCCESS:
        dd7acdfb-e0b5-679f-4e21-8ae9ac25c1d9:
          x: 361
          y: 311
