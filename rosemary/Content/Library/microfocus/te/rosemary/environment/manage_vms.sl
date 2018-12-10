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
    - get_vm_names:
        do:
          microfocus.te.rosemary.environment.subflows.get_vm_names:
            - parent_id: '${parent_id}'
            - vm_ids: '${vms_off}'
        publish:
          - vm_names
        navigate:
          - FAILURE: on_failure
          - SUCCESS: power_off_vms
    - power_off_vms:
        parallel_loop:
          for: vm_name in vm_names
          do:
            microfocus.te.rosemary.environment.manage_vm:
              - vm_name: '${vm_name}'
              - operation: power_off
              - environments: '${environments}'
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_vm_names_1
    - power_on_vms:
        parallel_loop:
          for: vm_name in vm_names
          do:
            microfocus.te.rosemary.environment.manage_vm:
              - vm_name: '${vm_name}'
              - operation: power_on
              - environments: '${environments}'
        publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_vm_names_1:
        do:
          microfocus.te.rosemary.environment.subflows.get_vm_names:
            - parent_id: '${parent_id}'
            - vm_ids: '${vms_on}'
        publish:
          - vm_names
        navigate:
          - FAILURE: on_failure
          - SUCCESS: power_on_vms
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_vm_names:
        x: 140
        y: 131
      power_off_vms:
        x: 336
        y: 132
      power_on_vms:
        x: 321
        y: 287
        navigate:
          38992a50-23d3-131c-2cbd-eacc93dfe85c:
            targetId: cb264364-c198-e3b1-d7b8-d9c473e3e5d7
            port: SUCCESS
      get_vm_names_1:
        x: 127
        y: 289
    results:
      SUCCESS:
        cb264364-c198-e3b1-d7b8-d9c473e3e5d7:
          x: 540
          y: 194
