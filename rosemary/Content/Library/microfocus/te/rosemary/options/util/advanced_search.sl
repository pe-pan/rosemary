namespace: microfocus.te.rosemary.options.util
flow:
  name: advanced_search
  inputs:
    - props_type
    - props_pathset
    - props_root_obj_type:
        required: false
    - props_root_obj:
        required: false
  workflow:
    - advanced_search:
        do:
          io.cloudslang.vmware.vcenter.util.advanced_search:
            - host: "${get_sp('host')}"
            - user: "${get_sp('user')}"
            - password:
                value: "${get_sp('password')}"
                sensitive: true
            - props_type: '${props_type}'
            - props_pathset: '${props_pathset}'
            - props_root_obj_type: '${props_root_obj_type}'
            - props_root_obj: '${props_root_obj}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        publish:
          - exception
          - return_code
          - return_result
          - number_of_results
        navigate:
          - SUCCESS: SUCCESS
          - NO_MORE: SUCCESS
          - FAILURE: on_failure
  outputs:
    - exception: '${exception}'
    - return_code: '${return_code}'
    - return_result: '${return_result}'
    - number_of_results: '${number_of_results}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      advanced_search:
        x: 118
        y: 87
        navigate:
          3fc36427-6e42-fb94-1ca0-2272658e1262:
            targetId: a65df0d1-83d0-438b-0d06-5a9b8a94ced5
            port: SUCCESS
          913b7532-0418-9a89-c710-50807ad0b107:
            targetId: a65df0d1-83d0-438b-0d06-5a9b8a94ced5
            port: NO_MORE
    results:
      SUCCESS:
        a65df0d1-83d0-438b-0d06-5a9b8a94ced5:
          x: 273
          y: 81
