########################################################################################################################
#!!
#! @input parent_id: ID of parent environment where the VMs are taken from
#! @input vms_off: List of VM IDs to power off
#! @input vms_on: List of VM IDs to power on
#! @input environments: List of IDs of environments to apply
#!!#
########################################################################################################################
namespace: Integrations.microfocus.te.rosemary.environment
flow:
  name: manage_vms
  inputs:
    - parent_id: resgroup-77479
    - vms_off: vm-82169
    - vms_on: vm-78152
    - environments: 'resgroup-76119,resgroup-82685,resgroup-77417,resgroup-82683,resgroup-82681,resgroup-76099,resgroup-76096,resgroup-76116,resgroup-77422,resgroup-76118,resgroup-76109,resgroup-76113,resgroup-76103,resgroup-76104,resgroup-82682,resgroup-77479,resgroup-76114,resgroup-76115,resgroup-76102,resgroup-76110,resgroup-82684,resgroup-82680,resgroup-76100,resgroup-77418,resgroup-76107,resgroup-76117,resgroup-76097,resgroup-76112,resgroup-76101,resgroup-76105,resgroup-76111,resgroup-77421,resgroup-77419,resgroup-76106,resgroup-82679,resgroup-77420'
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
            Integrations.microfocus.te.rosemary.environment.manage_vm:
              - vm_name: '${vm_name}'
              - operation: power_off
              - environments: '${environments}'
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
            Integrations.microfocus.te.rosemary.environment.manage_vm:
              - vm_name: '${vm_name}'
              - operation: power_on
              - environments: '${environments}'
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
