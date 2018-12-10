namespace: Integrations.microfocus.te.rosemary.test.rosemary.util.test_add_element
flow:
  name: add_element_all
  workflow:
    - add_element_into_empty_list:
        do:
          Integrations.microfocus.te.rosemary.test.rosemary.util.test_add_element.add_element_into_empty_list: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_element_into_non_empty_list
    - add_element_into_non_empty_list:
        do:
          Integrations.microfocus.te.rosemary.test.rosemary.util.test_add_element.add_element_into_non_empty_list: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_element_non_default_delimiter
    - add_element_non_default_delimiter:
        do:
          Integrations.microfocus.te.rosemary.test.rosemary.util.test_add_element.add_element_non_default_delimiter: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_element_cycle
    - add_element_cycle:
        do:
          Integrations.microfocus.te.rosemary.test.rosemary.util.test_add_element.add_element_cycle: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_element_into_empty_list:
        x: 95
        y: 50
      add_element_into_non_empty_list:
        x: 231
        y: 37
      add_element_non_default_delimiter:
        x: 394
        y: 46
      add_element_cycle:
        x: 551
        y: 53
        navigate:
          a97d6c62-0b67-61d3-0dbe-b14cf7274caf:
            targetId: 5c2e60e7-3a45-9322-acf7-83518e97be5f
            port: SUCCESS
    results:
      SUCCESS:
        5c2e60e7-3a45-9322-acf7-83518e97be5f:
          x: 689
          y: 51
