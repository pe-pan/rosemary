namespace: Integrations.microfocus.te.rosemary.environment.subflows
flow:
  name: get_name
  inputs:
    - parent_id: resgroup-41989
  workflow:
    - advanced_search:
        do:
          microfocus.te.rosemary.options.util.advanced_search:
            - props_type: VirtualMachine
            - props_pathset: name
            - props_root_obj_type: ResourcePool
            - props_root_obj: '${parent_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      advanced_search:
        x: 186
        y: 78
        navigate:
          88aee4da-6947-d2b7-29a1-3f1d3dbc61a1:
            targetId: a18d126c-4685-6cb1-4528-39a2cdfefc82
            port: SUCCESS
    results:
      SUCCESS:
        a18d126c-4685-6cb1-4528-39a2cdfefc82:
          x: 327
          y: 90
