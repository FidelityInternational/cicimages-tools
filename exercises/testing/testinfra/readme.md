# TestInfra
## Introduction
Automated testing is vital to the practices of continuous integration. Having an automated test suite that can be run on demand is crucial tool in understanding whether a code change can be confidently released to production.

The type of testing that is appropriate very much depends on the nature of the thing under test. When it comes to testing that infrastructure has been built correctly there is no substitute for going and checking the infrastructure after it has been built.

There are frameworks that can help do this in lots of languages. For python there is an API called [TestInfra](https://github.com/philpep/testinfra) and it is this API that we will use for purpose of this exercise

## Objectives
Write a test to check that the provided Ansible correctly deploys and configures and instance of Apache.

## Exercise
Some ansible has been written to create an environment running and Apache webserver. It's works most of the time but as it has been enhanced things that used to work keep braking... 

The right time to have put a test in place would have been right at the beginning before any Ansible was written, however a test is better than no test and late is better then never.

The requirements for the webserver as as follows:
* it should be running on port 80
* Have the rewrite mod loaded 
* and ... 

*Note:* All instructions given in this exercise assume:
* you have run . ./bin/setup from the root of the repository
* that you are executing commands from the same location as this readme is located.

### Run the ansible
run `ansible-playbook ansible/apache.yml`

This should give output that ends with something like the following
```
PLAY RECAP *********************************************************************
localhost                  : ok=n    changed=n    unreachable=0    failed=0   
```

The last line of the output will say somethink like:
```
[OK] FINISHED - connect with: cic start lvlup/ci_course:xxxxxxxxxxxx
```
This line isn't actually printed by Ansible itself, but a handy helper that has given you the instruction you need to connect to start the docker container that was built for you when you made the call to Ansible. Don't worry how this was done, it is not part of the leanring Ansible but simply some magic we've sprinkled to make sure that you almost no environmental/infrastructure setup to do before you get straight to learning the lesson at hand.

### Start the Apache environment and take a look around.
run the command that was at the end of the ansible-playbook output.
`cic start lvlup/ci_course:xxxxxxxxxxxx`

This will print the following:
```
Starting container: lvlup-ci_course-xxxxxxxxxxxx
     
connect to it with the 'cic connect' command.
E.g. cic connect lvlup-ci_course-xxxxxxxxxxxx
For more info run: cic connect help
```

The container built out by the ansible-playbook is now up and running and ready to be looked at. 

To connect the container press `ctrl+z` and then run `bg` to put the process in the background. Then using the actual container name given from the `cic start` run:
```
cic connect lvlup-ci_course-xxxxxxxxxxxx 
```

You will now be in bash shell on the container itself. From here run: `curl localhost:80` to see that apache is alive and well. `ctrl + d` will disconnect you from the container. 

Run `fg` to bring the active connection to the container back to the foreground and press `ctrl+c` to stop the container.

### Creating a basic test
