namespace: Integrations.microfocus.te.rosemary.test.rosemary.subflows.test_filter_list
flow:
  name: test_filter_all
  workflow:
    - test_empty_filter:
        do:
          Integrations.microfocus.te.rosemary.test.rosemary.subflows.test_filter_list.test_empty_filter: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: test_not_empty_filter
    - test_not_empty_filter:
        do:
          Integrations.microfocus.te.rosemary.test.rosemary.subflows.test_filter_list.test_not_empty_filter: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: test_filter_cycle
    - test_filter_cycle:
        do:
          Integrations.microfocus.te.rosemary.test.rosemary.subflows.test_filter_list.test_filter_cycle: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      test_empty_filter:
        x: 107
        y: 60
      test_not_empty_filter:
        x: 238
        y: 54
      test_filter_cycle:
        x: 375
        y: 58
        navigate:
          a09696b1-d158-642b-30cc-9f8d1f4369bd:
            targetId: 68eb903e-2ccb-0a25-f1d8-e31b33bfb0f1
            port: SUCCESS
    results:
      SUCCESS:
        68eb903e-2ccb-0a25-f1d8-e31b33bfb0f1:
          x: 508
          y: 59
