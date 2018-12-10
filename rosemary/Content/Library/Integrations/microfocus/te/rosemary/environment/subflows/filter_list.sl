########################################################################################################################
#!!
#! @description: Adds the prefix of VM name (with vm_id) into the given prefix_acc
#!
#! @input json: All VM ids and their names from the same folder
#! @input vm_id: ID of one of VM in the folder
#! @input prefix_acc: List to add one more prefix in
#!
#! @output prefixes: Prefixes of names of VMs in the folder
#!!#
########################################################################################################################
namespace: Integrations.microfocus.te.rosemary.environment.subflows
flow:
  name: filter_list
  inputs:
    - json
    - vm_id
    - prefix_acc:
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
          - SUCCESS: regex_replace
          - FAILURE: on_failure
    - add_element:
        do:
          Integrations.microfocus.te.rosemary.options.util.add_element:
            - list: '${prefix_acc}'
            - element: '${prefix}'
        publish:
          - prefixes: '${result_list}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - regex_replace:
        do:
          io.cloudslang.base.strings.regex_replace:
            - regex: "(^.*)(NET\\d+_\\d+)$"
            - text: '${vm_name}'
            - replacement: "\\1"
        publish:
          - prefix: '${result_text}'
        navigate:
          - SUCCESS: add_element
  outputs:
    - prefixes: '${prefixes}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      json_path_query:
        x: 118
        y: 82
      add_element:
        x: 278
        y: 217
        navigate:
          042dedb7-ca2f-943d-bd98-bc5b509f5b85:
            targetId: 8c55d923-34fa-757e-ef66-c5388b3ed054
            port: SUCCESS
      regex_replace:
        x: 113
        y: 218
    results:
      SUCCESS:
        8c55d923-34fa-757e-ef66-c5388b3ed054:
          x: 291
          y: 73
