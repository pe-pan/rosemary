namespace: microfocus.te.rosemary.options.subflows
flow:
  name: write_file
  inputs:
    - filename
    - json
  workflow:
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: "${get_sp('nfs_host')}"
            - command: "${'cd '+get_sp('nfs_folder')+' && echo \\''+json+'\\' > '+filename+' && chown 1999:1999 '+filename}"
            - username: "${get_sp('nfs_user')}"
            - password:
                value: "${get_sp('nfs_password')}"
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ssh_command:
        x: 193
        y: 126
        navigate:
          2a6acd56-a01f-90b9-8844-0fa02132f920:
            targetId: 04477234-5031-eef1-a830-4c036291a8a0
            port: SUCCESS
    results:
      SUCCESS:
        04477234-5031-eef1-a830-4c036291a8a0:
          x: 327
          y: 115
