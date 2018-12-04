namespace: Integrations.microfocus.te.rosemary.environment
flow:
  name: perform_operation
  inputs:
    - vm_id
    - operation
  workflow:
    - is_power_on:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${operation}'
            - second_string: power_on
        navigate:
          - SUCCESS: power_on_vm
          - FAILURE: is_power_off
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
          - FAILURE: SUCCESS
    - is_power_off:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${operation}'
            - second_string: power_off
        navigate:
          - SUCCESS: power_off_vm
          - FAILURE: on_failure
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
          - FAILURE: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_power_on:
        x: 172
        y: 53
      power_on_vm:
        x: 403
        y: 69
        navigate:
          0f357681-cf90-8a3f-6493-448c012c2c2f:
            targetId: 885d1d8b-81a6-d3f6-941b-a01732019366
            port: SUCCESS
          89b7ec62-42a5-9c58-96e9-cfbc0337f8d7:
            targetId: 885d1d8b-81a6-d3f6-941b-a01732019366
            port: FAILURE
      is_power_off:
        x: 174
        y: 235
      power_off_vm:
        x: 392
        y: 250
        navigate:
          295a663f-fcfe-9837-e996-7dc03e2a1558:
            targetId: 885d1d8b-81a6-d3f6-941b-a01732019366
            port: SUCCESS
          a72219e4-2f1c-1c5a-63b2-b411247c4315:
            targetId: 885d1d8b-81a6-d3f6-941b-a01732019366
            port: FAILURE
    results:
      SUCCESS:
        885d1d8b-81a6-d3f6-941b-a01732019366:
          x: 515
          y: 176
