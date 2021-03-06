########################################################################################################################
#!!
#! @input parent_id: ID of parent environment where the VMs are taken from
#! @input vm_ids: List of VM IDs to run the operations on
#!!#
########################################################################################################################
namespace: microfocus.te.rosemary.environment.subflows
flow:
  name: get_vm_prefixes
  inputs:
    - parent_id
    - vm_ids
  workflow:
    - advanced_search:
        do:
          microfocus.te.rosemary.util.advanced_search:
            - props_type: VirtualMachine
            - props_pathset: name
            - props_root_obj_type: ResourcePool
            - props_root_obj: '${parent_id}'
        publish:
          - json: '${return_result}'
          - prefix_acc: ''
        navigate:
          - FAILURE: on_failure
          - SUCCESS: filter_list
    - filter_list:
        loop:
          for: vm_id in vm_ids
          do:
            microfocus.te.rosemary.util.filter_list:
              - json: '${json}'
              - vm_id: '${vm_id}'
              - prefix_acc: '${prefix_acc}'
          break:
            - FAILURE
          publish:
            - prefix_acc: '${prefixes}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - prefixes: '${prefix_acc}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      advanced_search:
        x: 191
        y: 104
      filter_list:
        x: 347
        y: 106
        navigate:
          4c87a52f-69ac-bec0-e4c6-bcad60835df0:
            targetId: f34e9c64-53aa-eccf-d3a8-b01516b4ea20
            port: SUCCESS
    results:
      SUCCESS:
        f34e9c64-53aa-eccf-d3a8-b01516b4ea20:
          x: 484
          y: 106
