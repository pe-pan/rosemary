########################################################################################################################
#!!
#! @input parent_id: ID of parent environment where the VMs are taken from
#! @input vms_off: List of VM IDs to power off
#! @input vms_on: List of VM IDs to power on
#! @input environment_id: Environment ID to apply
#!!#
########################################################################################################################
namespace: Integrations.microfocus.te.rosemary.environment
flow:
  name: manage_vm
  inputs:
    - parent_id
    - vms_off
    - vms_on
    - environment_id
  workflow:
    - get_vm_names:
        do:
          Integrations.microfocus.te.rosemary.environment.subflows.get_vm_names:
            - parent_id: '${parent_id}'
            - vm_ids: '${vms_off}'
        publish:
          - vm_names
        navigate:
          - FAILURE: on_failure
          - SUCCESS: power_off_vms
    - power_off_vms:
        loop:
          for: vm_name in vm_names
          do:
            Integrations.microfocus.te.rosemary.environment.run_operation:
              - parent_id: '${environment_id}'
              - pattern_name: '${vm_name}'
              - operation: power_off
          break:
            - FAILURE
          publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_vm_names_1
    - power_on_vms:
        loop:
          for: vm_name in vm_names
          do:
            Integrations.microfocus.te.rosemary.environment.run_operation:
              - parent_id: '${environment_id}'
              - pattern_name: '${vm_name}'
              - operation: power_on
          break:
            - FAILURE
          publish: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_vm_names_1:
        do:
          Integrations.microfocus.te.rosemary.environment.subflows.get_vm_names:
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
