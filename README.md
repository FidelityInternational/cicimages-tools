# CIC
- [Introduction](#introduction)
- [Participants](#participants)
  - [Environment Requirements](#environment-requirements)
  - [Setup](#setup)
  - [Starting a learning track](#starting-a-learning-track)
  - [Individual Exercises](#individual-exercises)
- [Contributing](#contributing)

## Introduction
This course is intended to teach good practices around Infrastructure-as-Code development. This course contains a set of materials which are designed to teach you how to write tests for and automate the release of the things you build.

To undertake this course you will need a computer which you have full control over (i.e not your employer's desktop build) - It will need to be on a network with unrestricted access to the Internet (not behind locked-down corporate firewalls) as you will need to download and install a few components before you can begin.

Topics covered in this material:
```
Available Tracks:
 ansible
continuous_integration
```

To remove the need for dependencies on an external IaaS (Infrastructure as a Service) solution in order to participate in this course, this course has been designed to use Docker containers to simulate real computers.

The course is being actively built out so be sure to `git pull` regularly to get new exercises as they appear.

## Participants
### Environment Requirements
For this material you will need the following:
 - A Bash compatible environment
 - git
 - Docker - If you don't have it already, follow the instructions on the [Docker website](https://docs.docker.com/install/#next-release) to install it on your system
 - Editor of your choice
 - A browser

### Setup
1. create a .netrc file in your home directory with your credentials for github in it.
  Your entry should look something like this:
  ```
  machine api.github.com
      login <username>
      password <password>
  ```
  **Note:** If you are using MacOSX you might find that `~/.netrc` is a directory on your machine. In this case replace the directory for a file as described above.
2. Set restrictive permissions on `~/.netrc` e.g. by running: `chmod 0600 ~/.netrc`
3. Fork this repo
4. Clone your fork: `git clone https://github.com/<youruser>/<fork>.git cic`
5. cd in to your checkout: `cd cic`
6. setup the courseware: `./bin/setup`

### Starting a learning track
To see the Learning tracks that CIC contains run: `cic track list`
This will output the following
```
Available Tracks:
 ansible
continuous_integration
```

Start a track by running the `cic track start` command
E.g. `cic track start ansible --fork youruser/fork-name`

This creates a project in Github to guide you through the track and outputs its URL

Go to the the url and you'll see that there is a project board waiting for you. This board contains tickets for each of the exercises that you should complete to cover the topic you have chosen.

The board will allow you to track and share progress. When you complete an exercise, raise a pull request on your own fork to and get feedback from a peer to ensure you are getting the most from the exercise.

### Individual exercises
The exercises can be found inside the exercises folder. For each exercise there is a README.md which explains what is required. If you don't want to sit a whole learning track but want to brush up on something in particular, exercises can be found inside the exercises folder. For each exercise there is a README.md which explains what is required.

## Contributing
Many hands make light work and your help is needed! View the [Contributing Guide](./CONTRIBUTING.md) to find out what to do if you:
- spot a bug in the framework or an exercise
- think that a new exercise would be useful
- want to work on the CIC framework itself


  

Revision: 99cf1aafc06055b35d64900dc28594d8