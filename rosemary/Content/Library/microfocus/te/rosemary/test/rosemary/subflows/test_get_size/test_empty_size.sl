namespace: microfocus.te.rosemary.test.rosemary.subflows.test_get_size
flow:
  name: test_empty_size
  workflow:
    - get_size:
        do:
          microfocus.te.rosemary.environment.subflows.get_size:
            - json: '[]'
        publish:
          - size
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${size}'
            - second_string: '0'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_size:
        x: 85
        y: 87
      string_equals:
        x: 332
        y: 62
        navigate:
          0c60cf94-ebc7-91b4-544f-d382be8ff706:
            targetId: 0a67c817-c4d6-88e9-613f-102cbd230baf
            port: SUCCESS
    results:
      SUCCESS:
        0a67c817-c4d6-88e9-613f-102cbd230baf:
          x: 462
          y: 78
