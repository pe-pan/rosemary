namespace: Integrations.microfocus.te.rosemary.environment.subflows
flow:
  name: filter_list
  inputs:
    - json
    - vm_id
    - vm_names: ''
  workflow:
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: "${'$[?(@.morValue == \\''+vm_id+'\\')].name'}"
        publish:
          - vm_name: '${return_result[2:len(return_result)-2]}'
        navigate:
          - SUCCESS: add_element
          - FAILURE: on_failure
    - add_element:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${vm_names}'
            - element: '${vm_name}'
            - delimiter: ','
        publish:
          - vm_names: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
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
        x: 281
        y: 69
        navigate:
          dbf48bab-efe8-a1d5-e3fd-349b71f7a023:
            targetId: 8c55d923-34fa-757e-ef66-c5388b3ed054
            port: SUCCESS
    results:
      SUCCESS:
        8c55d923-34fa-757e-ef66-c5388b3ed054:
          x: 436
          y: 85
