namespace: Integrations.microfocus.te.rosemary.test.rosemary.subflows.test_get_size
flow:
  name: test_not_empty_size
  workflow:
    - get_size:
        do:
          Integrations.microfocus.te.rosemary.environment.subflows.get_size:
            - json: '[{"morValue":"vm-74200","name":"TO Delete - HCMDCA-VMDocker - 172.16.239.52_NET40_132_COPY"},{"morValue":"vm-72679","name":"ESxi5_HCM_NET40_132"},{"morValue":"vm-72663","name":"POCNG_WORKER-2018_08_ONE_NET40_132"},{"morValue":"vm-72662","name":"POCNG_MASTER-2018_08_NET40_132"},{"morValue":"vm-72571","name":"HCM-WIN-TOOLS-172.16.239.35_NET40_132"},{"morValue":"vm-71014","name":"ps-server_NET40_132"},{"morValue":"vm-71010","name":"mattermost-installed - 172.16.239.30_NET40_132"},{"morValue":"vm-71009","name":"HCMDCA-VMDocker - 172.16.239.52_NET40_132"},{"morValue":"vm-72664","name":"POCNG_WORKER-2018_08_TWO_NET40_132"},{"morValue":"vm-71008","name":"HCM - DNS-DHCP - 172.16.239.9_NET40_132"},{"morValue":"vm-74539","name":"Ubuntu Blank_NET40_132"},{"morValue":"vm-71007","name":"AccessVM-HCM_2018_08_NET40_132"}]'
        publish:
          - size
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${size}'
            - second_string: '12'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_size:
        x: 85
        y: 87
      string_equals:
        x: 332
        y: 62
        navigate:
          0c60cf94-ebc7-91b4-544f-d382be8ff706:
            targetId: 0a67c817-c4d6-88e9-613f-102cbd230baf
            port: SUCCESS
    results:
      SUCCESS:
        0a67c817-c4d6-88e9-613f-102cbd230baf:
          x: 462
          y: 78
