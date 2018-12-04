########################################################################################################################
#!!
#! @input parent_id: ID of parent environment where the VMs are taken from
#! @input vms_off: List of VM IDs to power off
#! @input vms_on: List of VM IDs to power on
#! @input environments: ID of environments to apply
#!!#
########################################################################################################################
namespace: Integrations.microfocus.te.rosemary.environment
flow:
  name: manage_vms
  inputs:
    - parent_id
    - vms_off
    - vms_on
    - environments
  results: []
