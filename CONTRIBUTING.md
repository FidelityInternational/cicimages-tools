

# Contributors Guide
- [Raising Issues](#raising-an-issue)
- [Submitting an exercise](#submitting-an-exercise)
  - [Getting started](#getting-started)
  - [The CIC content framework](#the-cic-content-framework)
    - [Documenting commands](#documenting-commands)
    - [Helpers](#helpers)
    - [Documenting command output](#documenting-command-output)
    - [Generating documentation](#generating-documentation)
  - [Resources](#resources)
  - [Defining support infrastructure](#defining-support-infrastructure)
    - [CIC_PWD](#cic_pwd)
    - [After Hook](#after-hook)

## Raising an issue
There are several types of issue that you can raise depending on what it is you are looking for.
- A new exercise
- A fix to a bug in an exercise or the courseware
- A new courseware feature

We've provided issue templates to help you make requests so look out for the issue type that best suits your request.

## Submitting an exercise
Exercises can consist of the following components:
- **Exercise readme** (mandatory).
- **Resources** - Additional bits and pieces needed to support the exercise.
- **Tests** - Exercises should be accompanied by a test(s) that participants can run to prove to themselves that they have completed the task correctly.
- **Test Infrastructure** - Many topics require an environment for participants to conduct the exercise within. The complexity of setting up these environments can represent a barrier to participants. CIC is built upon the philosophy that a participant should not be required to provide any infrastructure in order to carry out an exercise and uses docker-compose to achieve this.




### Getting started
**Note:** Before going any further do the following:
- `cd YOUR_CLONE_OF_THIS REPO`
- `source ./bin/env`

On the command line navigate to the place where the you intend to create your new exercise. For example, if you want to create a new exercise for ansible. Navigate to correct location within the CIC exercise directory structure and run `exercise create exercise_name`. This command will create a skeleton exercise directory with the all the files that you are likely to need.
```
Creating new exercise: exercise_name
Created: exercise_name/tests
Created: exercise_name/resources
Created: exercise_name/.cic
Created: exercise_name/.cic/docker-compose.yml
Created: exercise_name/.cic/after
Created: exercise_name/.templates
Created: exercise_name/.templates/README.md.erb
[OK] Complete

```


### The CIC content framework
Technical exercises can be complicated to write. They are full of commands, and example output, which if slightly incorrect causes confusion to the reader. Reading exercises through to ensure the accuracy of these things is time consuming and error prone.

To overcome this problem, the CIC content framework allows you to write and execute templates that can be used to generate your files. During the processing of templates, commands can be verified and their output can be inserted in to the documentation that is generated for the participant.

Files files in the `exercise_name/.templates` directory should end with the extension `.erb`. This identifies them as ERB files and that they should be picked up for processing. ERB is a markup format, the following is what you need to know in order to use CIC's content framework.

#### Documenting commands

To tell your reader to execute the a command, for example `mkdir new_directory`, specify the command within the template using the following syntax:
```ERB
  Please run the following command:  <%= command( 'mkdir new_directory') %>
```
In the above, the following is happening:
1. The helper method `command` is being invoked to run `mkdir new_directory`. `command` does two things:\
  a. It runs the command for real to see if it executes successfully. If the command does not work, generation will fail. This allows you to find out early when the commands you are telling participants to run don't actually work.  
  b. It returns the command you gave it so that it can be inserted in to the generated file.

2. The ` <%= %>` tags mean that you want the output of the `command` helper invocation to be written in to the generated file.

#### Helpers
The CIC content framework provides a number of helper functions that can be used to perform useful operations. To find out more about these read the [helpers docs](https://htmlpreview.github.io/?https://github.com/lvl-up/ci-cd-training/blob/master/doc/index.html). These helpers can be used at any point within a template as long as they are used within the `<% %>` or `<%= %>` style syntax described in this readme.

#### Documenting command output
There are 3 ways to display the output of a command
1. Use the `command_output` helper to return the output of the command directly.
2. Use the `last_command_output` to get hold of the output from the last command you ran using the `command` or `command_output` helpers
3. Memoisation
When you want to save the output of a command and use it after other uses of the `command` helper you can save the output against a variable and refer to that instead.
E.g.
```ERB
<% saved_command_output_variable = last_command_output %>
<%= saved_command_output_variable %>

```
#### Generating documentation

To render a template in the `.templates` directory, navigate to the root of your exercise directory pass the template path to the `exercise generate` command. For example running `exercise generate .templates/README.md.erb` will render the example README that was created by `exercise create`.

```
#################################################
# Generating template: .templates/README.md.erb #
#################################################
Rendering: .templates/README.md.erb
[OK] Finished: /vols/ansible_8558/exercise_name/.templates/README.md.erb

```

Files produced by the templates will be put in to the root of the exercise directory relative to their locations within the templates directory.

### Resources
You will often want to supply resources to support your exercise. Put these files within the `./resources` directory.

### Defining support infrastructure

Some exercises will require some kind of test infrastructure to for participants to run their exercise code against. The `cic up` wraps docker-compose to stand up the infrastructure you prescribe in `.cic/docker-compose.yml`. To read more about what can be done with docker-compose read the [documentation](https://docs.docker.com/compose/).

#### CIC_PWD
To reference files within the exercise directory, specify paths relative to the `CIC_PWD` environment variable. E.g. `${CIC_PWD}/resources/a_file`

#### After hook

There will be times where you want to wait for something to happen before the `cic up` command exits. For example you might want to wait for a server to be up and ready to receive requests. In this case add an executable file called `.cic/after`. Permissable languages within this file are: Bash, Ruby and Python.






  

Revision: 2a770f0128d202a069808503bef823ce
