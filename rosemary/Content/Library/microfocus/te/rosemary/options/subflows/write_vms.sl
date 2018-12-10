namespace: microfocus.te.rosemary.options.subflows
flow:
  name: write_vms
  inputs:
    - parent_id
    - parent_type
  workflow:
    - list_vms:
        do:
          microfocus.te.rosemary.options.subflows.list_vms:
            - parent_id: '${parent_id}'
            - parent_type: '${parent_type}'
        publish:
          - vms
        navigate:
          - SUCCESS: write_file
          - FAILURE: on_failure
    - write_file:
        do:
          microfocus.te.rosemary.options.subflows.write_file:
            - filename: '${parent_id}'
            - json: '${vms}'
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      list_vms:
        x: 122
        y: 130
      write_file:
        x: 263
        y: 130
        navigate:
          6ef41028-3b56-87a4-59c3-55151eb29f0b:
            targetId: 434c3357-fc5d-ab73-45f7-98a208771646
            port: SUCCESS
    results:
      SUCCESS:
        434c3357-fc5d-ab73-45f7-98a208771646:
          x: 383
          y: 122
