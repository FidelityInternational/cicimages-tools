
### Introduction
When thinking of the ways it's possible to ensure the quality of code, the most obvious method that springs to mind are automated tests. Automated tests check that code functions as required. However, test automation is not the only metric that can be used to determine the quality of code.

Lint is the bits of fluff on your clothes when you was and dry them. Lint is also the name given to code smells. I.e. suspicious code, that is seemingly non portable or a potential source of bugs.

Linting, isn't a new practice. Linting first started in [1978 at Bell Labs](https://en.wikipedia.org/wiki/Lint_(software)) and was a technique used to inspect C code for portability issues. Nowadays there are linters to look for all sorts of different code smells, from those that affect style and readility to those that warn of poor code coverage and potential vulnerabilities.

### Learning Objectives
- Discover the value of Linting

The intention of this exercise is not to exhaustively teach how to use a particular linter for a specific language, rather to introduce the value of using linters. This exercise does use pylint however, if Python is not a language you know, don't worry as very little knowledge of python is required. No matter what your experience of Python is, you should still get all of the intended value from this exercise. If you are interested in  specifically and want to do more extensive reading then check out the [project home page](https://www.pylint.org/) for more information.

## Required prequisite knowledge
This exercise assumes that you have basic knowledge of at least one programming. Although not essential, knowledge of an object oriented language might be useful.

### Tutorial
**Note:** Before going any further do the following:
- `cd YOUR_CLONE_OF_THIS REPO`
- `source ./bin/env`
- `cd ./exercises/CI/linting`

### Installing a Linter
All modern Languages have Linters. If your programming in Ruby you might use [Simplcov](https://github.com/colszowka/simplecov). If your using Python then, amongst others, there's [Pylint](https://www.pylint.org/). The means of installing will be specific to the Linter. In the case of Pylint and Simplecov both can be installed using their language's respective package managers (pip and gem).

### Linting your code
For this tutorial we'll be using pylint and have provided it as part of the CIC courseware.

Run `pylint` to see that the command is available.
```
Usage:  pylint [options] modules_or_packages

  Check that module(s) satisfy a coding standard (and more !).

    pylint --help

  Display this help message and exit.

    pylint --help-msg <msg-id>[,<msg-id>]

... lots more lines of help ...
```

Pylint needs some python code to look at so change directory to `cd resources` and run `ls src` and you'll see there is some code to run `pylint` against.
```
__init__.py
calculator.py
operations.py
```


Take a look at src/calculator.py
```PYTHON
"""
Calculator module
"""
from operations import AddOperation


class Calculator(object):
    """
    Provides interface for performing simple calculations
    """

    def __init__(self, start_value=0):
        """
        :param start_value: Initial value to start calculation with
        :type: int
        """
        self.start_value = start_value
        self.operations = []

    def add(self, value):

        self.operations.append(AddOperation(value))
        return self

    def reset(self):
        self.operations.clear()

    def result(self):
        """

        :return: the sum of all operations
        :rtype: float
        """
        result = self.start_value
        for operation in self.operations:
            result = operation.apply(result )
        return result
```

Looking at this code, it doesn't look to bad... and indeed it isn't. The tests are passing, functionally, this code is doing what it is supposed to.

It's not always easy to see where small errors and inconsistencies are in code. It's not what we as people are best at. Having a team mate review your code to point out missing white space or comments can also feel a bit personal and overly critical. This is where linters can step in. Linters can remove the time and critical edge out of the process of reviewing code. Linters can also find potential bugs in waiting that a functional test suite might not have highlighted.

run: `pylint src` to see what  thinks of our code.
```
************* Module src.calculator
src/calculator.py:36:44: C0326: No space allowed before bracket
            result = operation.apply(result )
                                            ^ (bad-whitespace)
src/calculator.py:7:0: R0205: Class 'Calculator' inherits from object, can be safely removed from bases in python3 (useless-object-inheritance)
src/calculator.py:20:4: C0111: Missing method docstring (missing-docstring)
src/calculator.py:25:4: C0111: Missing method docstring (missing-docstring)

-----------------------------------
Your code has been rated at 8.57/10
```

Sure enough there are a few issues. Some linters provide online documentation as to what these errors mean and examples of how they can be mitigated. Unfortunately it does not appear as though an up to date version of [this resource](http://pylint-messages.wikidot.com/all-codes) currently exists for , however it's still very much worth taking a look at.

#### It's all a matter of opinion
Linters are, by their very definition, opinionated and you might not always agree with the points that your linter raises. For example [C0111 - Missing method docstring](http://pylint-messages.wikidot.com/messages:c0111) is raised every time  sees that comments detailing a method's specification are missing. There is a school of thought that says that code itself should be self documenting. I.e it should be readable and that you should be able to tell what it does by reading it. Therefore some teams decide, to avoid ambiguity, that public APIs consumed by third parties should be documented but decide not to extensively document private APIs. Instead they choose to rely on the readability of the code, and the accompanying tests, to document what it does.

Linters whilst opinionated are flexible and allow themselves to be configured to the needs of their consumers. Therefore they can be tuned to change their sensitivity to certain issues or to disable particular checks altogether.

### Now it's your turn
fix the things that the linter has brought up and see if you can get pylint report the following :)

```
------------------------------------
Your code has been rated at 10.00/10
```

Don't forget to make sure that the tests are still passing after making your changes. Run pytest to execute them.
```
============================= test session starts ==============================
platform linux -- Python 3.7.0, pytest-3.8.2, py-1.7.0, pluggy-0.7.1 -- /root/.pyenv/versions/3.7.0/bin/python3.7
cachedir: .pytest_cache
rootdir: /vols/pytest_11668, inifile: pytest.ini
plugins: testinfra-1.16.0
collecting 0 items                                                             collecting 0 items                                                             collecting 3 items                                                             collecting 4 items                                                             collecting 4 items                                                             collected 4 items                                                              

tests/test_calculator_add.py::test_adds_value PASSED                     [ 25%]
tests/test_calculator_add.py::test_adds_on_to_running_total PASSED       [ 50%]
tests/test_calculator_add.py::test_minus_numbers PASSED                  [ 75%]
tests/test_calculator_result.py::test_is_0_by_default PASSED             [100%]

=========================== 4 passed in 0.02 seconds ===========================
```

## Summary
Linter's are an invaluable tool for digging out code smells. They are fast and unlike humans never have a lack in concertation when it comes to spotting issues lurking in the detail of our code. Linters are cheap to implement in a project if brought in at the very beginning and run continuously as part of continuous integration. However, if using a linter is left till later on in a project, then dealing with all the feedback that is generated can seem like a mountain to climb.

Linters are opinionated but can also be tuned to the needs of project, this gives the opportunity for team mates to agree on a set of principles and leave policing to the tool and their CI process.
  

Revision: 0a892c31d885a67d3a7dba404b7f17e1