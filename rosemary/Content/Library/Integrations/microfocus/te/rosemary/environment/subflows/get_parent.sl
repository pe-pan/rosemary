namespace: Integrations.microfocus.te.rosemary.environment.subflows
flow:
  name: get_parent
  inputs:
    - vm_id: vm-74539
  workflow:
    - advanced_search:
        do:
          microfocus.te.rosemary.options.util.advanced_search:
            - props_type: Folder
            - props_pathset: 'name,parent'
            - props_root_obj_type: VirtualMachine
            - props_root_obj: '${vm_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - parent_id
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      advanced_search:
        x: 187
        y: 131
        navigate:
          410b8f00-08f5-eb04-abdd-93ab78e09a6a:
            targetId: 1d4619f5-a092-a737-4d49-d910369b5a2e
            port: SUCCESS
    results:
      SUCCESS:
        1d4619f5-a092-a737-4d49-d910369b5a2e:
          x: 342
          y: 121
