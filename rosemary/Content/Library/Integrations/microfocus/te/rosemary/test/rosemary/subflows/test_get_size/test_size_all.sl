namespace: Integrations.microfocus.te.rosemary.test.rosemary.subflows.test_get_size
flow:
  name: test_size_all
  workflow:
    - test_empty_size:
        do:
          Integrations.microfocus.te.rosemary.test.rosemary.subflows.test_get_size.test_empty_size: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: test_not_empty_size
    - test_not_empty_size:
        do:
          Integrations.microfocus.te.rosemary.test.rosemary.subflows.test_get_size.test_not_empty_size: []
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      test_empty_size:
        x: 44
        y: 52
      test_not_empty_size:
        x: 203
        y: 49
        navigate:
          d44ab117-5705-131a-a8b9-a9f2f01f9f80:
            targetId: 549b3f2f-a4f0-113c-ee17-b78bd02c0c2f
            port: SUCCESS
    results:
      SUCCESS:
        549b3f2f-a4f0-113c-ee17-b78bd02c0c2f:
          x: 344
          y: 56
