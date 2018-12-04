namespace: Integrations.microfocus.te.rosemary.environment.subflows
flow:
  name: get_size
  inputs:
    - json: '[]'
  workflow:
    - sleep:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '0'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: how_many_results
    - how_many_results:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: $.length
        publish:
          - found_vms: '${return_result}'
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - size: "${str(json.count('{'))}"
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      sleep:
        x: 89
        y: 95
        navigate:
          f2437825-7c75-d7cc-2c83-7221889fa393:
            targetId: b28e8f30-3983-bfef-56b5-23b7acf8bd7e
            port: SUCCESS
      how_many_results:
        x: 385
        y: 219
        navigate:
          b514a44f-0b1d-d89f-8dc9-71738ce37c67:
            targetId: b28e8f30-3983-bfef-56b5-23b7acf8bd7e
            port: SUCCESS
    results:
      SUCCESS:
        b28e8f30-3983-bfef-56b5-23b7acf8bd7e:
          x: 286
          y: 92
