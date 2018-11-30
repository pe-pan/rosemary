namespace: Integrations.microfocus.te.rosemary
flow:
  name: list_vms
  inputs:
    - parent_id: resgroup-41989
    - parent_type:
        default: ResourcePool
        required: false
  workflow:
    - advanced_search:
        do:
          microfocus.te.rosemary.util.advanced_search:
            - props_type: VirtualMachine
            - props_pathset: name
            - props_root_obj_type: '${parent_type}'
            - props_root_obj: '${parent_id}'
        publish:
          - vms: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - vms: '${vms}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      advanced_search:
        x: 102
        y: 57
        navigate:
          fdf13df5-e5fa-0dd4-dfc5-70318aa776d7:
            targetId: c71e2ddb-cd92-a3b6-a78c-a66e48e11492
            port: SUCCESS
    results:
      SUCCESS:
        c71e2ddb-cd92-a3b6-a78c-a66e48e11492:
          x: 299
          y: 50
