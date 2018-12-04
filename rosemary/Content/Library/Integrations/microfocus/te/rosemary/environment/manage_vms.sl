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
    - parent_id: resgroup-41989
    - vms_off: 'vm-72571,vm-71009'
    - vms_on: 'vm-72571,vm-71009'
    - environments: 'resgroup-41989,resgroup-74997'
  workflow:
    - manage_vm:
        loop:
          for: environment_id in environments
          do:
            Integrations.microfocus.te.rosemary.environment.manage_vm:
              - parent_id: '${parent_id}'
              - vms_off: '${vms_off}'
              - vms_on: '${vms_on}'
              - environment_id: '${environment_id}'
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      manage_vm:
        x: 305
        y: 86
        navigate:
          aedee50d-2e9f-ab89-1c7c-2b0066c490d9:
            targetId: d730b734-c4a7-ab24-67de-f8e1f12f8b97
            port: SUCCESS
    results:
      SUCCESS:
        d730b734-c4a7-ab24-67de-f8e1f12f8b97:
          x: 438
          y: 82
