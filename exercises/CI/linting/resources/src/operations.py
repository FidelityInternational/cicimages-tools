"""
Calculator operations - module containing classes to perform the  mathematical operations
provided through a calculator.
"""

from abc import ABC, abstractmethod


class Operation(ABC):
    """
    Abstract class defining required interface for calculator operations
    """

    def __init__(self, value):
        self.value = value

    def __string__(self):
        """

        :return: A description of the instance
        :rtype string:
        """
        return f"{self.operation()} {self.value}"

    @abstractmethod
    def apply(self, running_total):
        """
        Interface method for applying an operation to a given valuee
        """

    @abstractmethod
    def operation(self):
        """
        Interface method to declare the operation
        """


class AddOperation(Operation):
    """
    Class used to apply addition operations
    """

    def apply(self, running_total):
        """
        Apply this add operation to the given value

        :param running_total: The value to which the operation should be applied
        :type running_total: int
        :return: the result having applied the operation
        :rtype :int
        """

        return running_total + self.value

    def operation(self):
        """
        Operation applied by this class of operation

        :return: the operation
        :rtype: string
        """
        return "+"
