namespace: microfocus.te.rosemary.options
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
    - get_prod_id:
        do:
          microfocus.te.rosemary.util.get_id:
            - json_object: '${datacenters}'
            - name: "${get_sp('folder_production')}"
        publish:
          - prod_id: '${id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_prod_folders
    - get_lib_id:
        do:
          microfocus.te.rosemary.util.get_id:
            - json_object: '${datacenters}'
            - name: "${get_sp('folder_library')}"
        publish:
          - lib_id: '${id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_lib_folders
    - get_dev_id:
        do:
          microfocus.te.rosemary.util.get_id:
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
          microfocus.te.rosemary.util.get_id:
            - json_object: '${prod_folders}'
            - name: Classes
        publish:
          - classes_id: '${id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_classes
    - get_classes:
        do:
          microfocus.te.rosemary.util.get_children:
            - json_object: '${prod_folders}'
            - parent_id: '${classes_id}'
            - parent_type: Folder
        publish:
          - classes: '${children}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: write_file
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
          microfocus.te.rosemary.util.get_id:
            - json_object: '${lib_folders}'
            - name: Resources
        publish:
          - resources_id: '${id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_libraries
    - get_libraries:
        do:
          microfocus.te.rosemary.util.get_children:
            - json_object: '${lib_folders}'
            - parent_id: '${resources_id}'
            - parent_type: ResourcePool
        publish:
          - libraries: '${children}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: write_file_1
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
          - FAILURE: on_failure
          - SUCCESS: get_environments
    - get_environments:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${dev_folders}'
            - json_path: "$[?(@.parent =~ /.*ResourcePool}/i)]['name','morValue']"
        publish:
          - envrironments: '${return_result}'
        navigate:
          - SUCCESS: write_file_2
          - FAILURE: on_failure
    - write_file:
        do:
          microfocus.te.rosemary.options.subflows.write_file:
            - filename: classes.json
            - json: '${classes}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_to_list
    - json_to_list:
        do:
          microfocus.te.rosemary.util.json_to_list:
            - json: '${classes}'
            - property: morValue
        publish:
          - class_ids: '${list}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: write_pools
    - write_file_1:
        do:
          microfocus.te.rosemary.options.subflows.write_file:
            - filename: libraries.json
            - json: '${libraries}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_to_list_1
    - json_to_list_1:
        do:
          microfocus.te.rosemary.util.json_to_list:
            - json: '${libraries}'
            - property: morValue
        publish:
          - library_ids: '${list}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: write_vms_1
    - write_vms_1:
        loop:
          for: library_id in library_ids
          do:
            microfocus.te.rosemary.options.subflows.write_vms:
              - parent_id: '${library_id[1:-1]}'
              - parent_type: ResourcePool
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_dev_id
    - write_pools:
        loop:
          for: class_id in class_ids
          do:
            microfocus.te.rosemary.options.subflows.write_pools:
              - parent_id: '${class_id[1:-1]}'
              - parent_type: Folder
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: get_lib_id
    - write_vms_1_1:
        loop:
          for: environment_id in environment_ids
          do:
            microfocus.te.rosemary.options.subflows.write_vms:
              - parent_id: '${environment_id[1:-1]}'
              - parent_type: ResourcePool
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
    - write_file_2:
        do:
          microfocus.te.rosemary.options.subflows.write_file:
            - filename: environments.json
            - json: '${envrironments}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: json_to_list_2
    - json_to_list_2:
        do:
          microfocus.te.rosemary.util.json_to_list:
            - json: '${envrironments}'
            - property: morValue
        publish:
          - environment_ids: '${list}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: write_vms_1_1
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
      write_vms_1_1:
        x: 676
        y: 490
        navigate:
          5adae391-aa74-da53-9f67-83ac5ddc7429:
            targetId: 2f2613cf-d594-7e80-95a1-a868e77ab0b6
            port: SUCCESS
      get_lib_folders:
        x: 151
        y: 298
      get_prod_folders:
        x: 114
        y: 130
      get_environments:
        x: 275
        y: 477
      json_to_list:
        x: 608
        y: 151
      get_all_datacenters:
        x: 140
        y: 11
      write_vms_1:
        x: 744
        y: 320
      get_dev_id:
        x: 25
        y: 446
      write_file_1:
        x: 500
        y: 328
      write_file_2:
        x: 402
        y: 485
      get_libraries:
        x: 368
        y: 297
      get_dev_folders:
        x: 153
        y: 483
      write_pools:
        x: 736
        y: 152
      get_prod_id:
        x: 8
        y: 128
      write_file:
        x: 487
        y: 154
      get_classes:
        x: 359
        y: 142
      get_classes_id:
        x: 240
        y: 135
      json_to_list_1:
        x: 626
        y: 341
      json_to_list_2:
        x: 539
        y: 491
      get_lib_id:
        x: 11
        y: 291
      get_resources_id:
        x: 251
        y: 302
    results:
      SUCCESS:
        2f2613cf-d594-7e80-95a1-a868e77ab0b6:
          x: 764
          y: 626
