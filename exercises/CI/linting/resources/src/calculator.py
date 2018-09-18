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
