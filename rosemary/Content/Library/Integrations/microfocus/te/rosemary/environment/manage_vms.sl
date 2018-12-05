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
