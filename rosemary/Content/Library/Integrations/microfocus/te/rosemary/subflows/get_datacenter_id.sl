namespace: microfocus.te.rosemary.subflows
flow:
  name: get_datacenter_id
  inputs:
    - id
    - json
  workflow:
    - advanced_search_2:
        do:
          microfocus.te.rosemary.util.advanced_search:
            - props_type: Datacenter
            - props_pathset: name
            - props_root_obj_type: Datacenter
            - props_root_obj: '${id}'
        publish:
          - datacenter_json: '${return_result}'
        navigate:
          - SUCCESS: json_path_query_2
          - NO_MORE: json_path_query_2
          - FAILURE: on_failure
    - json_path_query_2:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${datacenter_json}'
            - json_path: '$.[0].name'
        publish:
          - name: '${return_result}'
        navigate:
          - SUCCESS: add_json_property_to_object
          - FAILURE: on_failure
    - add_json_property_to_object:
        do:
          io.cloudslang.base.json.add_json_property_to_object:
            - json_object: '${json}'
            - key: '${name[1:len(name)-1]}'
            - value: "${'\\''+id+'\\''}"
        publish:
          - json: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - json_object: '${json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      advanced_search_2:
        x: 93
        y: 84
        navigate:
          c50a7a54-89c6-3f0a-2aa8-0ef70b921853:
            vertices: []
            targetId: json_path_query_2
            port: NO_MORE
      json_path_query_2:
        x: 89
        y: 307
      add_json_property_to_object:
        x: 354
        y: 299
        navigate:
          343adcab-2bea-e8d3-a7c8-f1320e75c043:
            targetId: 5e2c6624-7924-3513-d060-485911a9aa6b
            port: SUCCESS
    results:
      SUCCESS:
        5e2c6624-7924-3513-d060-485911a9aa6b:
          x: 356
          y: 93
