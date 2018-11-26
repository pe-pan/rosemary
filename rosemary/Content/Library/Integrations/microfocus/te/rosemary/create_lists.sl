namespace: microfocus.te.rosemary
flow:
  name: create_lists
  workflow:
    - get_all_datacenters:
        do:
          microfocus.te.rosemary.util.advanced_search:
            - props_type: Datacenter
            - props_pathset: 'name,parent'
            - props_root_obj_type: null
            - props_root_obj: null
        publish:
          - datacenters: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_prod_id
    - find_root:
        do:
          microfocus.te.rosemary.util.advanced_search:
            - props_type: Folder
            - props_pathset: 'name,childEntity'
        publish:
          - all_json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_datacenter_ids
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
    - get_prod_id:
        do:
          Integrations.microfocus.te.rosemary.util.get_id:
            - json_object: '${datacenters}'
            - name: "${get_sp('folder_production')}"
        publish:
          - prod_id: '${id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_prod_folders
    - get_lib_id:
        do:
          Integrations.microfocus.te.rosemary.util.get_id:
            - json_object: '${datacenters}'
            - name: "${get_sp('folder_library')}"
        publish:
          - lib_id: '${id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_lib_folders
    - get_dev_id:
        do:
          Integrations.microfocus.te.rosemary.util.get_id:
            - json_object: '${datacenters}'
            - name: "${get_sp('folder_development')}"
        publish:
          - dev_id: '${id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_dev_folders
    - get_prod_folders:
        do:
          microfocus.te.rosemary.util.advanced_search:
            - props_type: Folder
            - props_pathset: 'name,parent'
            - props_root_obj_type: Datacenter
            - props_root_obj: '${prod_id}'
        publish:
          - prod_folders: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_classes_id
    - get_classes_id:
        do:
          Integrations.microfocus.te.rosemary.util.get_id:
            - json_object: '${prod_folders}'
            - name: Classes
        publish:
          - classes_id: '${id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_classes
    - get_classes:
        do:
          Integrations.microfocus.te.rosemary.util.get_children:
            - json_object: '${prod_folders}'
            - parent_id: '${classes_id}'
            - parent_type: Folder
        publish:
          - classes: '${children}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_lib_id
    - get_lib_folders:
        do:
          microfocus.te.rosemary.util.advanced_search:
            - props_type: ResourcePool
            - props_pathset: 'name,parent'
            - props_root_obj_type: Datacenter
            - props_root_obj: '${lib_id}'
        publish:
          - lib_folders: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_resources_id
    - get_resources_id:
        do:
          Integrations.microfocus.te.rosemary.util.get_id:
            - json_object: '${lib_folders}'
            - name: Resources
        publish:
          - resources_id: '${id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_libraries
    - get_libraries:
        do:
          Integrations.microfocus.te.rosemary.util.get_children:
            - json_object: '${lib_folders}'
            - parent_id: '${resources_id}'
            - parent_type: ResourcePool
        publish:
          - libraries: '${children}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_dev_id
    - get_dev_folders:
        do:
          microfocus.te.rosemary.util.advanced_search:
            - props_type: ResourcePool
            - props_pathset: 'name,parent'
            - props_root_obj_type: Datacenter
            - props_root_obj: '${dev_id}'
        publish:
          - dev_folders: '${return_result}'
        navigate:
          - FAILURE: find_root
          - SUCCESS: get_environments
    - get_environments:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${dev_folders}'
            - json_path: "$[?(@.parent =~ /.*ResourcePool}/i)]['name','morValue']"
        publish:
          - envrironments: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - classes: '${classes}'
    - libraries: '${libraries}'
    - environments: '${envrironments}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_datacenter_ids:
        x: 535
        y: 76
      get_lib_folders:
        x: 151
        y: 298
      get_prod_folders:
        x: 114
        y: 130
      find_root:
        x: 430
        y: 50
      get_production_folders:
        x: 560
        y: 218
      get_environments:
        x: 276
        y: 477
        navigate:
          dbc698e5-277c-9c23-5023-ba5de5380818:
            targetId: 2f2613cf-d594-7e80-95a1-a868e77ab0b6
            port: SUCCESS
      get_all_datacenters:
        x: 140
        y: 11
      get_dev_id:
        x: 25
        y: 478
      get_libraries:
        x: 368
        y: 297
      get_datacenter_names:
        x: 716
        y: 96
      get_dev_folders:
        x: 153
        y: 483
        navigate:
          acc89751-31b0-ba41-0d5a-637f78601fcc:
            vertices:
              - x: 307
                y: 349
              - x: 408
                y: 195
            targetId: find_root
            port: FAILURE
      get_library_folders:
        x: 507
        y: 562
        navigate:
          01bb166a-1832-0a26-154b-16c978d389dd:
            targetId: 2f2613cf-d594-7e80-95a1-a868e77ab0b6
            port: SUCCESS
      get_prod_id:
        x: 8
        y: 128
      get_classes:
        x: 359
        y: 142
      get_classes_id:
        x: 240
        y: 134
      get_lib_id:
        x: 11
        y: 291
      get_resources_id:
        x: 251
        y: 302
    results:
      SUCCESS:
        2f2613cf-d594-7e80-95a1-a868e77ab0b6:
          x: 385
          y: 514
