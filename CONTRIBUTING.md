

# Contributors Guide
- [Raising Issues](#raising-an-issue)
- [Submitting an exercise](#submitting-an-exercise)
  - [Getting started](#getting-started)
  - [CIC content framework](#.templates)
    - [Documenting commands](#documenting-a-command)
    - [Documenting command output](#documenting-command-output)
    - [Generating documentation](#generating-documentation)
  - [Resources](#resources)
  - [Defining support infrastructure](#defining-support-infrastructure)

## Raising an issue
There are several types of issue that you can raise depending on what it is you are looking for.
- A new exercise
- A fix to a bug in an exercise or the courseware
- A new courseware feature

We've provided issue templates to help you make requests so look out for the issue type that best suits your request.

## Submitting an exercise
Exercises can consist of the following components:
- **Exercise readme**
- **Resources** - Additional bits and pieces needed to support the exercise
- **Tests** - Exercises should be accompanied by a test(s) that participants can run to prove to themselves that they have completed the task correctly
- **Test Infrastructure** - Many topics require an environment for participants to conduct the exercise within. This represent a barrier to participants especially if the environment is a complex one. CIC is built upon the philosophy that a participant should not be required to provide any infrastructure in order to carry out an exercise. CIC uses docker and docker-compose to achieve this.




### Getting started
On the command line navigate to the place where the you intend to create your new exercise. For example the, if you want to create a new exercise for ansible. Navigate to correct location within the CIC exercise directory structure and run `exercise create exercise_name`. This command will create a skeleton exercise directory with the all the files that you are likely to need.
```
Creating new exercise: exercise_name
Created: exercise_name/tests
Created: exercise_name/.templates
Created: exercise_name/.templates/README.md.erb
Created: exercise_name/resources
Created: exercise_name/.cic
Created: exercise_name/.cic/docker-compose.yml
Created: exercise_name/.cic/after
[OK] Complete

```


### .templates
Technical exercises can be complicated to write. They are full of commands, and example output, which if slightly incorrect can cause massive confusion to the reader. Reading exercises through to ensure the accuracy of these things is time consuming and error prone.

To overcome this problem, the CIC content framework allows you to write and execute templates that can be used to generate your files. During the processing of templates, commands can be verified and their output can be inserted in to the documentation that is generated for the participant.

By default, you are given the file `exercise_name/.templates/README.md.erb`, from which the mandatory exercise README.md will be generated.

Files files in the `exercise_name/.templates` directory should end with the extension `.erb`. This identifies them as ERB files and that they should be picked up for processing. ERB is a markup format, the following is what you need to know in order to use CIC's content framework.

#### documenting a command

To tell your reader to execute the a command, for example `mkdir new_directory`, specify the command within the template using the following syntax:
```ERB
  Please run the following command:  <%= command( 'mkdir new_directory') %>
```
In the above, the following is happening:
1. The helper method `command` is being invoked to run `mkdir new_directory`. `command` does two things:
  a. It runs the command for real to see if it executes successfully. If the command does not work, generation will fail. This allows you to find out early when the commands you are telling participants to run don't actually work.
  b. It returns the command you gave it so that it can be inserted in to the generated file.
2. The  <%= %> tags mean that you want the output of the `command` helper invocation to be written in to the generated file.

#### Helpers
The CIC content framework provides a number of helper functions that can be used to perform useful operations. To find out more about these read the [helpers docs](). These helpers can be used at any point within a template as long as they are used within the `<% %>` or `<%= %>` style syntax described in this readme.

#### documenting command output
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

To render the templates in the `.templates` directory, navigate to the root of your exercise directory and run `exercise generate`.
```
#############################
# Generating exercise files #
#############################
Generating file for: README.md.erb
[OK] Finished: README.md.erb

```

Files produced by the templates will be put in to the root of the exercise directory relative to their locations within the templates directory.

### resources
You will often want to supply resources to support your exercise. Put these files within the resources directory.

### Defining support infrastructure

Some exercises will require some kind of test infrastructure to for participants to run their exercise code against. The `cic up` wraps docker-compose to stand up the infrastructure you prescribe in `.cic/docker-compose.yml`. To read more about what can be done with docker-compose read the [documentation](https://docs.docker.com/compose/).

#### CIC_PWD
To reference files within the exercise directory, specify paths relative to the `CIC_PWD` environment variable. E.g. `${CIC_PWD}/resources/a_file`

#### After hook

There will be times where you want to wait for something to happen before the `cic up` command exits. For example you might want to wait for a server to be up and ready to receive requests. In this case add an executable file called `.cic/after`. Permissable languages within this file are: Bash, Ruby and Python.





  

Revision: e9ee1e2dded8c9c26dbb6650a364b57a739ae44c6f889f853dcc4e11b27ef01a