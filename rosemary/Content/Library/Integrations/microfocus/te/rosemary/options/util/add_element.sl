namespace: Integrations.microfocus.te.rosemary.options.util
flow:
  name: add_element
  inputs:
    - list:
        required: false
    - element
    - delimiter:
        default: ','
        required: false
  workflow:
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '0'
        publish: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - result_list: '${list+delimiter+element if list else element}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      sleep:
        x: 137
        y: 135
        navigate:
          5e87c53e-e713-eeb5-fb75-c4bde155de4c:
            targetId: 96b71de0-a131-90a1-d14a-5389ee312c9b
            port: SUCCESS
    results:
      SUCCESS:
        96b71de0-a131-90a1-d14a-5389ee312c9b:
          x: 257
          y: 127
