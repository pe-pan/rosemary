namespace: microfocus.te.rosemary
flow:
  name: create_lists
  inputs:
    - host: "${get_sp('host')}"
    - user: "${get_sp('user')}"
    - password: "${get_sp('password')}"
  workflow:
    - find_root_1:
        do:
          io.cloudslang.vmware.vcenter.util.advanced_search:
            - host: "${get('host', get_sp('host'))}"
            - user: '${user}'
            - password: '${password}'
            - props_type: ResourcePool
            - props_pathset: 'name,parent'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        publish:
          - all_json: '${return_result}'
        navigate:
          - SUCCESS: find_root
          - NO_MORE: find_root
          - FAILURE: on_failure
    - find_root:
        do:
          io.cloudslang.vmware.vcenter.util.advanced_search:
            - host: "${get('host', get_sp('host'))}"
            - user: '${user}'
            - password: '${password}'
            - props_type: Folder
            - props_pathset: 'name,childEntity'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        publish:
          - all_json: '${return_result}'
        navigate:
          - SUCCESS: get_datacenter_ids
          - NO_MORE: get_datacenter_ids
          - FAILURE: on_failure
    - get_datacenter_ids:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${all_json}'
            - json_path: "$.[?(@.name=='Datacenters')].childEntity"
        publish:
          - datacenters_string: '${return_result[2:len(return_result)-2]}'
          - items: "${str(len(return_result[2:len(return_result)-2].split('},{')))}"
          - json_collection: '{}'
        navigate:
          - SUCCESS: get_datacenter_names
          - FAILURE: on_failure
    - get_datacenter_names:
        loop:
          for: "string in datacenters_string.split('},{')"
          do:
            microfocus.te.rosemary.subflows.get_datacenter_id:
              - host: '${host}'
              - user: '${user}'
              - password: '${password}'
              - id: '${string[string.find("_value:")+7:string.find(",")]}'
              - json: '${json_collection}'
          break:
            - FAILURE
          publish:
            - json_collection: '${json_object}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_production_folders
    - get_production_folders:
        do:
          microfocus.te.rosemary.subflows.get_datacenter_entities:
            - json_collection: '${json_collection}'
            - name: "${get_sp('folder_production')}"
            - user: '${user}'
            - password: '${password}'
            - filter_on: Folder
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_library_folders
    - get_library_folders:
        do:
          microfocus.te.rosemary.subflows.get_datacenter_entities:
            - json_collection: '${json_collection}'
            - name: "${get_sp('folder_library')}"
            - user: '${user}'
            - password: '${password}'
            - filter_on: ResourcePool
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_datacenter_names:
        x: 530
        y: 94
      find_root:
        x: 125
        y: 92
      get_datacenter_ids:
        x: 345
        y: 83
      get_production_folders:
        x: 204
        y: 270
      get_library_folders:
        x: 393
        y: 320
        navigate:
          01bb166a-1832-0a26-154b-16c978d389dd:
            targetId: 2f2613cf-d594-7e80-95a1-a868e77ab0b6
            port: SUCCESS
      find_root_1:
        x: 93
        y: 258
    results:
      SUCCESS:
        2f2613cf-d594-7e80-95a1-a868e77ab0b6:
          x: 704
          y: 299
