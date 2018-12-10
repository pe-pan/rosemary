########################################################################################################################
#!!
#! @input parent_id: ID of parent environment where the VMs are taken from
#! @input vms_off: List of VM IDs to power off
#! @input vms_on: List of VM IDs to power on
#! @input environments: List of IDs of environments to apply
#!!#
########################################################################################################################
namespace: microfocus.te.rosemary.environment
flow:
  name: manage_vms
  inputs:
    - parent_id: resgroup-41989
    - vms_off: 'vm-72571,vm-71009'
    - vms_on: 'vm-72571,vm-71009'
    - environments: 'resgroup-41989,resgroup-74997'
  workflow:
    - get_vm_prefixes_off:
        do:
          microfocus.te.rosemary.environment.subflows.get_vm_prefixes:
            - parent_id: '${parent_id}'
            - vm_ids: '${vms_off}'
        publish:
          - prefixes
        navigate:
          - FAILURE: on_failure
          - SUCCESS: power_off_vms
    - power_off_vms:
        parallel_loop:
          for: prefix in prefixes
          do:
            microfocus.te.rosemary.environment.manage_vm:
              - prefix: '${prefix}'
              - vm_name: '${prefix}'
              - operation: power_off
              - environments: '${environments}'
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_vm_prefixes_on
    - get_vm_prefixes_on:
        do:
          microfocus.te.rosemary.environment.subflows.get_vm_prefixes:
            - parent_id: '${parent_id}'
            - vm_ids: '${vms_on}'
        publish:
          - prefixes
        navigate:
          - FAILURE: on_failure
          - SUCCESS: power_on_vms
    - power_on_vms:
        parallel_loop:
          for: prefix in prefixes
          do:
            microfocus.te.rosemary.environment.manage_vm:
              - prefix: '${prefix}'
              - vm_name: '${prefix}'
              - operation: power_on
              - environments: '${environments}'
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
      get_vm_prefixes_off:
        x: 140
        y: 131
      power_off_vms:
        x: 336
        y: 132
      get_vm_prefixes_on:
        x: 127
        y: 289
      power_on_vms:
        x: 324
        y: 287
        navigate:
          38992a50-23d3-131c-2cbd-eacc93dfe85c:
            targetId: cb264364-c198-e3b1-d7b8-d9c473e3e5d7
            port: SUCCESS
    results:
      SUCCESS:
        cb264364-c198-e3b1-d7b8-d9c473e3e5d7:
          x: 540
          y: 194
