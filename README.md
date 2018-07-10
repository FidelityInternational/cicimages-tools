# CIC Bootcamp
## Introduction
This course is intended to teach good practices around Infrastructure-as-Code development. This course contains a set of materials which are designed to teach you how to write tests for and automate the release of the things you build. 

To undertake this course you will need a computer which you have full control over (i.e not your employer's desktop build) - It will need to be on a network with unrestricted access to the Internet (not behind locked-down corporate firewalls) as you will need to download and install a few components before you can begin.

Topics covered in this material:
- Ansible (configuration as code)
- Testing 
- Continuous Integration
- Continuous Deployment

To remove the need for dependencies on an external IaaS (Infrastructure as a Service) solution in order to participate in this course, it has been designed to run inside an Ubuntu virtual machine, using Docker containers to simulate real computers.

The course is being actively built out so be sure to `git pull` regularly to get new exercises as they appear.

## Participants

## Getting Started
### Environment Requirements
For this material you will need the following: 
 - an Ubuntu 18.04 Virtual Machine
 - git
 - Editor of your choice

### Manual Setup
0. Install [Oracle VM Virtualbox](https://www.virtualbox.org)
0. Download an [Ubuntu 18.04 Desktop ISO Image](https://releases.ubuntu.com/releases/18.04)
0. Follow the [Instructions for installing Ubuntu](https://linuxhint.com/install_ubuntu_18-04_virtualbox/)
0. Once installation is completed, log into the VM and start a Bash shell
0. Clone the repo: `git clone https://github.com/lvl-up/ci-cd-training.git` (***maybe need to `sudo apt-get install git` first***)
0. cd in to checkout: `cd ci-cd-training`
0. `source ./bin/setup`

###
## Dashboard
The exercises in this course are designed to be completed as standalone training exercises - However if you wish to work through this course in a structured order we have provided a dashboard to guide you through a suggested track.

## Exercises
The exercises can be found inside the exercises folder. For each exercise there is a README.md which explains what is required.

## Collaborators
We are seeking collaborators to assist with refinig the current exercises and generating additional ones. If you would like to collaborate on this course, please see the [collaborator documentation](https://whevs)



