namespace: Integrations.microfocus.te.rosemary.test.rosemary.util.test_add_element
flow:
  name: add_element_cycle
  inputs:
    - list:
        default: ''
        required: false
  workflow:
    - add_element:
        loop:
          for: 'element in range(1,6)'
          do:
            Integrations.microfocus.te.rosemary.options.util.add_element:
              - list: '${list}'
              - element: '${str(element)}'
              - delimiter: /
          break:
            - FAILURE
          publish:
            - list: '${result_list}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: string_equals
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${list}'
            - second_string: 1/2/3/4/5
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
