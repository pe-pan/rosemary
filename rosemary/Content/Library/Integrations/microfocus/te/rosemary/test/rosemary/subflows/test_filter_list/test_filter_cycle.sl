namespace: Integrations.microfocus.te.rosemary.test.rosemary.subflows.test_filter_list
flow:
  name: test_filter_cycle
  inputs:
    - prefixes:
        default: ''
        required: false
  workflow:
    - filter_list:
        loop:
          for: "vm_id in 'vm-74200,vm-72679,vm-72663'"
          do:
            Integrations.microfocus.te.rosemary.environment.subflows.filter_list:
              - json: >-
                  [
                    {
                      "morValue": "vm-74200",
                      "name": "TO Delete - HCMDCA-VMDocker - 172.16.239.52_NET40_132"
                    },
                    {
                      "morValue": "vm-72679",
                      "name": "ESxi5_HCM_NET40_132"
                    },
                    {
                      "morValue": "vm-72663",
                      "name": "POCNG_WORKER-2018_08_ONE_NET40_132"
                    }
                  ]
              - vm_id: '${vm_id}'
              - prefix_acc: '${prefixes}'
          break:
            - FAILURE
          publish:
            - prefixes
        navigate:
          - FAILURE: on_failure
          - SUCCESS: string_equals
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${prefixes}'
            - second_string: 'TO Delete - HCMDCA-VMDocker - 172.16.239.52_,ESxi5_HCM_,POCNG_WORKER-2018_08_ONE_'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      filter_list:
        x: 192
        y: 107
      string_equals:
        x: 396
        y: 107
        navigate:
          d379e9ec-7bc6-5301-c0dc-e9a421bce06c:
            targetId: 380b8d19-ec6f-8cb5-a3b3-51c97a6e9bcb
            port: SUCCESS
    results:
      SUCCESS:
        380b8d19-ec6f-8cb5-a3b3-51c97a6e9bcb:
          x: 496
          y: 115
