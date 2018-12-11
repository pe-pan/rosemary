########################################################################################################################
#!!
#! @input parent_id: List of VMs (ID, name) in this one environment
#! @input prefix: Pattern (VM name) that is to be searched
#! @input operation: Which operation to run
#!!#
########################################################################################################################
namespace: microfocus.te.rosemary.environment
flow:
  name: run_operation
  inputs:
    - parent_id: resgroup-41989
    - prefix: ps-server_NET41_13
    - operation:
        default: power_on
        required: false
    - not_found_vms: '[]'
    - found_too_many_times_vms: '[]'
  workflow:
    - advanced_search:
        do:
          microfocus.te.rosemary.util.advanced_search:
            - props_type: VirtualMachine
            - props_pathset: name
            - props_root_obj_type: ResourcePool
            - props_root_obj: '${parent_id}'
        publish:
          - found_vms: '${return_result}'
          - filtered_json: '[]'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_path_query
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${found_vms}'
            - json_path: "${\"$[?(@.name =~ /\"+prefix+\".*/)].['name','morValue']\"}"
        publish:
          - filtered_json: '${return_result}'
        navigate:
          - SUCCESS: get_size
          - FAILURE: on_failure
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
          microfocus.te.rosemary.environment.perform_operation:
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
          - vm_id: '${return_result[1:-1]}'
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
          microfocus.te.rosemary.environment.subflows.get_size:
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
        x: 29
        y: 73
      add_into_too_many_array:
        x: 530
        y: 241
        navigate:
          6ed5110c-947f-d9e9-56ab-cd68fcf45854:
            targetId: 69f2b956-4d74-a7d4-84df-1e93b4d7fe69
            port: SUCCESS
      json_path_query:
        x: 194
        y: 64
      only_one_vm_found:
        x: 385
        y: 53
      perform_operation:
        x: 745
        y: 72
        navigate:
          46fc7a5a-55f3-47ff-c820-d306f1ca4087:
            targetId: 69f2b956-4d74-a7d4-84df-1e93b4d7fe69
            port: SUCCESS
      get_size:
        x: 191
        y: 239
      zero_found:
        x: 387
        y: 317
      add_into_not_found_array:
        x: 532
        y: 405
        navigate:
          bf675100-3ffb-04d6-4086-a50141f34352:
            targetId: 69f2b956-4d74-a7d4-84df-1e93b4d7fe69
            port: SUCCESS
      get_vm_id:
        x: 527
        y: 71
    results:
      SUCCESS:
        69f2b956-4d74-a7d4-84df-1e93b4d7fe69:
          x: 762
          y: 325
