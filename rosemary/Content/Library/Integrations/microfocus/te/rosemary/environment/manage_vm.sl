namespace: Integrations.microfocus.te.rosemary.environment
flow:
  name: manage_vm
  inputs:
    - vm_id: vm-74539
    - vm_power_state: power_on
  workflow:
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vm_power_state}'
            - second_string: power_off
        navigate:
          - SUCCESS: power_off_vm
          - FAILURE: power_on_vm
    - power_off_vm:
        do:
          io.cloudslang.vmware.vcenter.power_off_vm:
            - host: "${get_sp('host')}"
            - user: "${get_sp('user')}"
            - password:
                value: "${get_sp('password')}"
                sensitive: true
            - vm_identifier: vmid
            - vm_name: '${vm_id}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - power_on_vm:
        do:
          io.cloudslang.vmware.vcenter.power_on_vm:
            - host: "${get_sp('host')}"
            - user: "${get_sp('user')}"
            - password:
                value: "${get_sp('password')}"
                sensitive: true
            - vm_identifier: vmid
            - vm_name: '${vm_id}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      power_on_vm:
        x: 459
        y: 83
        navigate:
          0d0837a0-b657-1ef1-8797-fa207dbb4c9a:
            targetId: 16196002-7c68-12f1-ab34-f4ea5c087f28
            port: SUCCESS
      string_equals:
        x: 310
        y: 71
      power_off_vm:
        x: 279
        y: 262
        navigate:
          caa87287-488e-0d6d-05a3-323bc287ab1d:
            targetId: 16196002-7c68-12f1-ab34-f4ea5c087f28
            port: SUCCESS
    results:
      SUCCESS:
        16196002-7c68-12f1-ab34-f4ea5c087f28:
          x: 447
          y: 268
