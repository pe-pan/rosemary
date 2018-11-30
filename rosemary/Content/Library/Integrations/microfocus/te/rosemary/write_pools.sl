namespace: Integrations.microfocus.te.rosemary
flow:
  name: write_pools
  inputs:
    - parent_id
    - parent_type
  workflow:
    - list_pools:
        do:
          Integrations.microfocus.te.rosemary.list_pools:
            - parent_id: '${parent_id}'
            - parent_type: '${parent_type}'
        publish:
          - pools
        navigate:
          - SUCCESS: filter_pools
          - FAILURE: on_failure
    - write_file:
        do:
          Integrations.microfocus.te.rosemary.write_file:
            - filename: '${parent_id}'
            - json: '${pools}'
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_to_list
    - json_to_list:
        do:
          Integrations.microfocus.te.rosemary.json_to_list:
            - json: '${pools}'
            - property: morValue
        publish:
          - pool_ids: '${list}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: write_vms
    - write_vms:
        loop:
          for: pool_id in pool_ids
          do:
            Integrations.microfocus.te.rosemary.write_vms:
              - parent_id: '${pool_id[1:len(pool_id)-1]}'
              - parent_type: ResourcePool
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - filter_pools:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${pools}'
            - json_path: "$[?(@.parent =~ /.*ResourcePool}/i)]['name','morValue']"
        publish:
          - pools: '${return_result}'
        navigate:
          - SUCCESS: write_file
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      list_pools:
        x: 86
        y: 144
      write_file:
        x: 263
        y: 130
      json_to_list:
        x: 413
        y: 136
      write_vms:
        x: 532
        y: 143
        navigate:
          4fe0e0c1-2ce3-335e-e027-f35352cbaaea:
            targetId: 434c3357-fc5d-ab73-45f7-98a208771646
            port: SUCCESS
      filter_pools:
        x: 193
        y: 286
    results:
      SUCCESS:
        434c3357-fc5d-ab73-45f7-98a208771646:
          x: 644
          y: 150
