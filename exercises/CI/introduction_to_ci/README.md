# Introduction to Continuous Integration (CI)









## Introduction
Development teams working on a common codebase are **continuously** making changes to that common code. In order for a team member to know that their changes are compatible, **continuous** checking of the code base should be happening too. I.e. every time some one makes a change, the code base should be tested to ensure it is continuing to work as intended. The idea is that the more frequently changes are integrated, the smaller those changes are likely to be and therefore the lower the risk is that they will break something. This is where the practice of Continuous Integration (CI) comes in.

> Continuous Integration is a software development practice where members of a team integrate their work frequently, usually each person integrates at least daily - leading to multiple integrations per day. Each integration is verified by an automated build (including test) to detect integration errors as quickly as possible. Many teams find that this approach leads to significantly reduced integration problems and allows a team to develop cohesive software more rapidly.
- Martin Fowler: [https://martinfowler.com/articles/continuousIntegration.html](https://martinfowler.com/articles/continuousIntegration.html)

Traditionally, large systems are very difficult to change and time consuming to verify. This results in new releases only being made a few times a year. These release are usually high risk, high anxiety, events due to their manual and error prone nature. CI is an automated process, this means, with careful management, that as the code base grows the time taken verify the code base should remain short (ideally just a few minutes). This has the knock on effect that new releases can be prepared and released frequently. Frequent, high quality, releases benefit the business and take the pressure off of the team.

### Continuous Integration Servers
Continuous integration servers are essentially glorified schedulers. They sit looking at your Version Control System (VCS) and when they see that a change has been introduced they do what ever they have been configured to do. E.g. to compile the new version of the code base and run a set of tests to see if it still works. Different CI servers may have different user interfaces, however they essentially all do the same thing and have a very common feature set. Therefore learn how to use one CI server and you should find that switching to another is a pretty easy process.

## Exercise Learning Objectives
- Introduction Concourse CI

## Exercise
**Note:** Before going any further do the following:
- `cd YOUR_CLONE_OF_THIS REPO`
- `source ./bin/env`
- `cd ./exercises/CI/introduction_to_ci`

In this exercise you will be working using a CI server called Concourse. We've done the hard bit and have provided you with your very own Concourse installation. We've also provided you with a GIT server for your CI server to talk to. To start everything up, run: `cic up` 

If all is well you should see the following:
```
  waiting for Concourse to come up: 
waiting for Concourse to come up: 
waiting for Concourse to come up:
[OK] Environment cic'd up :)

```

Click the login button at the top right of the [concourse home page](http://127.0.0.1:8080) and login with username `test` and password `test`. You'll note that there arn't currently any 'pipelines' configured. A pipeline is the name that Concourse gives to one or more tasks/jobs that have been configured to be run in a prescribed order when a particular event happens. E.g. a change is detected in GIT. Pipelines can be can be as simple as a one step process or they can be used to model very complex processes. In a later exercise we'll go in to pipelines and there features in more depth.

We have supplied a very simple pipeline. Let's put it in to concourse.

Some CI's have extensive UIs through which they can be configured, Concourse is primarly configured via it's commandline interface (CLI) which makes webservice calls to configure the Concourse server. The CLIs for each O/S are available in `./resources` directory. Use the fly binary that is correct for your O/S to complete this exercise.

First we must login, run `./resources/linux/fly -t local login --concourse-url http://127.0.0.1:8080 -u test -p test`
you should see the following output:
```
logging in to team 'main'


target saved
```

Now let's push a pipeline to concourse by running: `./resources/linux/fly  -t local set-pipeline -p ci-intro-pipeline -c ./resources/pipeline.yml -n`
you should see the following output:
```
resources:
  resource repo has been added:
  + name: repo
  + type: git
  + source:
  +   branch: master
  +   private_key: |
  +     -----BEGIN RSA PRIVATE KEY-----
  +     MIIEowIBAAKCAQEAxEm/zZgCBVH1n//fMRTUYQCcY9JXFwnW9ijrz78xcpTR9bi3
  +     sm3fiRV5S1HFXu2dHkpGimfSBTHdnQi74uppW2tmKRIt3ovP1893L+0JUtDGvRHt
  +     7ICg0BVxiP5NCKHV4/dIi0WyRme/Xl0CI7O15WyK3eECRYlJXPUfSzJ4LBSEL6oj
  +     wNGyWHLeNlYLtXYW0o5L8dwPjO8P2U55q27OdCF4UQf+u8Axc/LpVFL8tjCQmS9O
  +     kR1b+kygVikCOsGSPxTE3KjfeC278F0cToCh5FhBxb5pNcD/IQI9iv/1uDFXHb5r
  +     bGM43eY1++BAnRa8CrqCZsGgbPtRSogMv6hYywIDAQABAoIBAAou6Ux5PmGYRu3u
  +     EF4zfnEp3vMuzmXblNNgfBtjB+Wx4tKkqqMPIDG0c35814h9O1F++PnlOPgcBitH
  +     cLftAVpE0CABWW/aQQYpNT2/RmSNgEH+1CEY6z7gXeuFhemUu8v/4DuZeg49A6iZ
  +     mqrPf/hPEUVBjyScYrn33Y/BJorizkBr4F7W1FV10tFjJyzvFZgEOn+qgT5yjeO5
  +     N6P+NAkvEtkPyaAASfqISE9yEFBMpaMAiJ8S/pK+h2HA6uy+gP7xU3+hWixDOIdu
  +     GJUgZcj4Ue34q1n36fGCRjoMpOxfnL9JjCpGF2YZfy54eX9GN1vTJ8nSyOlMDsko
  +     zxplIQECgYEA9Ee4KZ322k3fxsIT4lKUOCOvAVVAMaNf8oVbNJVTdkNbjDqznJm7
  +     xjTXjgNPCaVej50967MDn0kvrIGy6/X6Bk7A+0A+WaPqMcjNHbFjGDFUsc4X5x2r
  +     4FUd+8nKghGvuK1AnKzhRFNcFIDjHYZ6ooSv2yDZBH2aiWDRmek7GdsCgYEAzbSV
  +     wemxCusW/GhdOaSrd7+Z1NwU3wubb/reiVy+lHjSRJ93uEkGreUvn2cfrQPMIr4J
  +     z1IVGGt1Vpg0FAkJ+cJfppo+akzuP0Nfzi7PnXlUqWUVPdRfhHyqc2ypyIFr2Y2I
  +     Y9gIwaDCWrTXMPYasl4Y1nvtONeDG9l6y76dx9ECgYARBs63V+NU5Ais+eoY5Fig
  +     cRxJo3+N9i1B4jmxOJdQrvE6nPzX9X85GYXMyD5CFdy5deRTAW9HMvq3s3KdL8/1
  +     kJey649tABfa0Hw7jZmynf2hRxQzb8YDJOuqGS6cUk9FOA5A3Wv2LzlD1Jf//ted
  +     bFI1m9yEi5yx5qW1bKRJ8QKBgQCqwiSrExYfjSXIo833ouWgA1Jsq8E7ooQGwgbn
  +     mjCuSVmrE4GrXhuIUT9mIJHf6s4TbRPxoR7X5aRDHRfmJda9GQiT4Wi8j14a8A/g
  +     tWUtQOHxuHKYn+omreJE7MhIJH9l2iKFV3l1WsDb0VDtWO6ycIBH1BoJXIV+odtY
  +     tMR/cQKBgE2L/lEzFR+/d80d39ECGGaCllC2F2cGz/BSWNle5Cp7PVs8y23yG3HG
  +     iOCmPStUUZ7hi8OVjfsszJqv/z/Tp6kx/hNHXoPFmGcD4G6JyiifwlGG4tLMsO+g
  +     SJm2WgmccOTu2RVpUkBcPKgxENQWO85QnTF9MlVjjuGRelWcrXwi
  +     -----END RSA PRIVATE KEY-----
  +   uri: ssh://git@git-server/git-server/repos/application-repo.git
  
jobs:
  job my-first-job has been added:
  + name: my-first-job
  + plan:
  + - do:
  +   - aggregate:
  +     - get: repo
  +       trigger: true
  +   - task: pointless-echo
  +     config:
  +       platform: linux
  +       image_resource:
  +         type: docker-image
  +         source:
  +           repository: alpine
  +       run:
  +         path: sh
  +         args:
  +         - -e
  +         - -c
  +         - -x
  +         - |
  +           echo "Something worked"
  +       inputs:
  +       - name: repo
  
pipeline created!
you can view your pipeline here: http://127.0.0.1:8080/teams/main/pipelines/ci-intro-pipeline

the pipeline is currently paused. to unpause, either:
  - run the unpause-pipeline command
  - click play next to the pipeline in the web ui
```



Visit the [concourse home page](http://127.0.0.1:8080) again and you'll see the pipeline that the was just pushed.
![Pending Pipeline](./pending_pipeline_screenshot.png)


You'll notice the following:
- there is now a pipe line called: `ci-intro-pipeline`
- the pipeline is paused

When pipelines are first pushed, they are not enabled. In order to run the pipeline we need to unpause it. Do this by either clicking the play symbol or by running: `./resources/linux/fly -t local unpause-pipeline -p ci-intro-pipeline`. Unpausing the pipeline should cause Concourse to trigger a build for our new pipeline. Go back to the [detailed view of the pipeline](http://127.0.0.1:8080/teams/main/pipelines/ci-intro-pipeline) after 20 seconds or so, you'll notice that that pipeline goes green. This means that the code has been pulled successfully from GIT and that the singe job, that is in the pipeline, has executed successfully.

![Passing Pipeline](./passing_pipeline_screenshot.png)
### Now it's your turn
You are part of a team who has been working on a new application, a team member has carefully made a change to the code and is recommending that the change be released straight to production. Nothing could possibly go wrong!... could it?

to complete this exercise do the following:

1. Push the project pipeline to concourse - The pipeline file can be found in `./resources/application-pipeline.yml`
**Note:** Make sure that it is enabled and runs successfully.


2. The proposed change sits uncommitted in `./resources/checkout`.
```
  On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   src/application.py

no changes added to commit (use "git add" and/or "git commit -a")
```
The checkout is pointed at the GIT server that was brought up for you when you ran the `cic up` command. Running `git remote get-url origin` within the checkout directory shows that the GIT server is indeed on your local machine.
```
ssh://git@localhost:3333/git-server/repos/application-repo.git
```
Commit and push your team mate's changes to GIT and see what the Concourse makes of it :)
**Hint** If you don't know how to use git. Investigate (in that order):
- git add
- git commit
- git push



## Summary
Continuous Integration plays a vital role in ensuring that the software we right works as intended. As the number of team members and the complexity of a code base goes up, simply being careful is an approach that is guaranteed to fail more often than it succeeds. If business confidence/satisfaction is going to remain high, then the quality and the frequency with which we deliver our software must remain high also. CI isn't a nice to have, rather it is essential and should pretty much be the first thing to be implemented in a project.

**Note:** Now that you've finished the exercise, remember to run `cic down` to shutdown your test infrastructure.
  

Revision: 6245cceeacb3599130d99f21026953fa