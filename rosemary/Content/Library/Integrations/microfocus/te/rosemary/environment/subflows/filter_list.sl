namespace: Integrations.microfocus.te.rosemary.environment.subflows
flow:
  name: filter_list
  inputs:
    - json
    - vm_id
    - vm_names:
        required: false
  workflow:
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$[?(@.morValue == \\''+vm_id+'\\')].name'}"
        publish:
          - vm_name: '${return_result[2:-2]}'
        navigate:
          - SUCCESS: add_element
          - FAILURE: on_failure
    - add_element:
        do:
          Integrations.microfocus.te.rosemary.options.util.add_element:
            - list: '${vm_names}'
            - element: '${vm_name}'
        publish:
          - vm_names: '${result_list}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  outputs:
    - names_list: '${vm_names}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      json_path_query:
        x: 114
        y: 79
      add_element:
        x: 273
        y: 89
        navigate:
          042dedb7-ca2f-943d-bd98-bc5b509f5b85:
            targetId: 8c55d923-34fa-757e-ef66-c5388b3ed054
            port: SUCCESS
    results:
      SUCCESS:
        8c55d923-34fa-757e-ef66-c5388b3ed054:
          x: 436
          y: 85
