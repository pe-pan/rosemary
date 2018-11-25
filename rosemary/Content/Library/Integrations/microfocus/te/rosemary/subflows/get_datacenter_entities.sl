namespace: microfocus.te.rosemary.subflows
flow:
  name: get_datacenter_entities
  inputs:
    - json_collection
    - name
    - filter_on
  workflow:
    - get_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json_collection}'
            - json_path: "${'$.'+name}"
        publish:
          - id: '${return_result[1:len(return_result)-1]}'
        navigate:
          - SUCCESS: advanced_search
          - FAILURE: on_failure
    - advanced_search:
        do:
          microfocus.te.rosemary.util.advanced_search:
            - props_type: '${filter_on}'
            - props_pathset: 'name,parent'
            - props_root_obj_type: Datacenter
            - props_root_obj: '${id}'
        publish:
          - children: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
  outputs:
    - children: '${children}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_id:
        x: 100
        y: 150
      advanced_search:
        x: 400
        y: 150
        navigate:
          322d72b6-2c65-3309-1299-cad6bd6c0013:
            targetId: 0dd1bf8c-36d8-21ef-c6fb-fd2c413df340
            port: SUCCESS
          03ba98b2-774b-a0b4-c354-c7d4825e729b:
            targetId: 0dd1bf8c-36d8-21ef-c6fb-fd2c413df340
            port: NO_MORE
    results:
      SUCCESS:
        0dd1bf8c-36d8-21ef-c6fb-fd2c413df340:
          x: 700
          y: 150
