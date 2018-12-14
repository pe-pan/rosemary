namespace: microfocus.te.rosemary.test
flow:
  name: all_tests
  workflow:
    - test_size_all:
        do:
          microfocus.te.rosemary.test.rosemary.subflows.test_get_size.test_size_all: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: add_element_all
    - add_element_all:
        do:
          microfocus.te.rosemary.test.rosemary.util.test_add_element.add_element_all: []
        navigate:
          - SUCCESS: test_filter_all
    - test_filter_all:
        do:
          microfocus.te.rosemary.test.rosemary.subflows.test_filter_list.test_filter_all: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_element_all:
        x: 207
        y: 103
      test_size_all:
        x: 42
        y: 107
      test_filter_all:
        x: 370
        y: 103
        navigate:
          a9e36b16-ce19-785b-d0bf-494863ca7e74:
            targetId: e20eea7c-6bf5-207b-9dd5-e670c9ea0994
            port: SUCCESS
    results:
      SUCCESS:
        e20eea7c-6bf5-207b-9dd5-e670c9ea0994:
          x: 519
          y: 118
