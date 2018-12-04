########################################################################################################################
#!!
#! @input parent_id: List of VMs (ID, name) in this one environment
#! @input pattern_name: Pattern (VM name) that is to be searched
#! @input operation: Which operation to run
#!!#
########################################################################################################################
namespace: Integrations.microfocus.te.rosemary.environment
flow:
  name: run_operation
  inputs:
    - parent_id: resgroup-41989
    - pattern_name: ps-server_NET41_13
    - operation:
        default: power_on
        required: false
    - not_found_vms: '[]'
    - found_too_many_times_vms: '[]'
  workflow:
    - regex_replace:
        do:
          io.cloudslang.base.strings.regex_replace:
            - regex: "(^.*)(NET\\d+_\\d+)$"
            - text: '${pattern_name}'
            - replacement: "\\1"
        publish:
          - prefix: '${result_text}'
        navigate:
          - SUCCESS: advanced_search
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${found_vms}'
            - json_path: "$[?(@.morValue =~ /.*74200/i)]['name']['morValue']"
        publish:
          - list: '${return_result}'
          - return_code
          - exception
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - advanced_search:
        do:
          microfocus.te.rosemary.options.util.advanced_search:
            - props_type: VirtualMachine
            - props_pathset: name
            - props_root_obj_type: ResourcePool
            - props_root_obj: '${parent_id}'
        publish:
          - found_vms: '${return_result}'
          - filtered_json: '[]'
        navigate:
          - FAILURE: json_path_query
          - SUCCESS: json_to_list
    - filter_json:
        loop:
          for: vm_id in vms_list
          do:
            Integrations.microfocus.te.rosemary.environment.subflows.filter_json:
              - json: '${found_vms}'
              - prefix: '${prefix}'
              - filtered_json: '${filtered_json}'
              - vm_id: '${vm_id[1:len(vm_id)-1]}'
          break:
            - FAILURE
          publish:
            - filtered_json: '${result_json}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_size
    - json_to_list:
        do:
          microfocus.te.rosemary.options.util.json_to_list:
            - json: '${found_vms}'
            - property: morValue
        publish:
          - vms_list: '${list}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: filter_json
    - only_one_vm_found:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${size}'
            - second_string: '1'
        navigate:
          - SUCCESS: get_vm_id
          - FAILURE: zero_found
    - perform_operation:
        do:
          Integrations.microfocus.te.rosemary.environment.perform_operation:
            - vm_id: '${vm_id}'
            - operation: '${operation}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - get_vm_id:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${filtered_json}'
            - json_path: '$[0].morValue'
        publish:
          - vm_id: '${return_result[1:len(return_result)-1]}'
        navigate:
          - SUCCESS: perform_operation
          - FAILURE: on_failure
    - add_into_not_found_array:
        do:
          io.cloudslang.base.json.add_object_into_json_array:
            - json_array: '${not_found_vms}'
            - json_object: "${\"{'name':'\"+prefix+\"','parent':'\"+parent_id+\"'}\"}"
        publish:
          - not_found_vms: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - add_into_too_many_array:
        do:
          io.cloudslang.base.json.add_object_into_json_array:
            - json_array: '${found_too_many_times_vms}'
            - json_object: "${\"{'name':'\"+prefix+\"','parent':'\"+parent_id+\"'}\"}"
        publish:
          - found_too_many_times_vms: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_size:
        do:
          Integrations.microfocus.te.rosemary.environment.subflows.get_size:
            - json: '${filtered_json}'
        publish:
          - size
        navigate:
          - SUCCESS: only_one_vm_found
          - FAILURE: on_failure
    - zero_found:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${size}'
            - second_string: '0'
        navigate:
          - SUCCESS: add_into_not_found_array
          - FAILURE: add_into_too_many_array
  outputs:
    - not_found_vms_out: '${not_found_vms}'
    - found_too_many_times_vms_out: '${found_too_many_times_vms}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      advanced_search:
        x: 139
        y: 54
      add_into_too_many_array:
        x: 135
        y: 326
        navigate:
          6ed5110c-947f-d9e9-56ab-cd68fcf45854:
            targetId: 69f2b956-4d74-a7d4-84df-1e93b4d7fe69
            port: SUCCESS
      json_path_query:
        x: 343
        y: 15
        navigate:
          90abc8fe-c961-bc99-e2ab-a36f25828ee1:
            targetId: 69f2b956-4d74-a7d4-84df-1e93b4d7fe69
            port: SUCCESS
      only_one_vm_found:
        x: 434
        y: 378
      perform_operation:
        x: 669
        y: 398
        navigate:
          46fc7a5a-55f3-47ff-c820-d306f1ca4087:
            targetId: 69f2b956-4d74-a7d4-84df-1e93b4d7fe69
            port: SUCCESS
      get_size:
        x: 365
        y: 127
      zero_found:
        x: 322
        y: 294
      json_to_list:
        x: 39
        y: 229
      add_into_not_found_array:
        x: 507
        y: 255
        navigate:
          bf675100-3ffb-04d6-4086-a50141f34352:
            targetId: 69f2b956-4d74-a7d4-84df-1e93b4d7fe69
            port: SUCCESS
      filter_json:
        x: 195
        y: 154
      get_vm_id:
        x: 526
        y: 428
      regex_replace:
        x: 16
        y: 75
    results:
      SUCCESS:
        69f2b956-4d74-a7d4-84df-1e93b4d7fe69:
          x: 679
          y: 97
