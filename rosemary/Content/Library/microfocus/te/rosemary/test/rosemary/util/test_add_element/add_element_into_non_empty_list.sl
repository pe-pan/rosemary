namespace: microfocus.te.rosemary.test.rosemary.util.test_add_element
flow:
  name: add_element_into_non_empty_list
  workflow:
    - add_element:
        do:
          microfocus.te.rosemary.util.add_element:
            - list: original_element
            - element: element
        publish:
          - result_list
        navigate:
          - FAILURE: on_failure
          - SUCCESS: string_equals
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${result_list}'
            - second_string: 'original_element,element'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      add_element:
        x: 98
        y: 95
      string_equals:
        x: 326
        y: 80
        navigate:
          def496c5-a9c7-aea5-f72a-937980829957:
            targetId: d8df2c70-6a5c-f801-ac94-05de3d5380c7
            port: SUCCESS
    results:
      SUCCESS:
        d8df2c70-6a5c-f801-ac94-05de3d5380c7:
          x: 481
          y: 97
