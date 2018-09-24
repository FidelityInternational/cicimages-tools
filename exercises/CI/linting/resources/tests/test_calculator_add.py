from calculator import Calculator
import pytest

@pytest.fixture
def subject():
    calc = None
    if not calc:
        calc = Calculator()
    return calc

def test_adds_value(subject):
    expected_value = 3
    subject.add(expected_value)
    assert subject.result() == expected_value

def test_adds_on_to_running_total(subject):
    subject.add(3)
    subject.add(3)
    assert subject.result() == 6

def test_minus_numbers(subject):
    expected_value = -3
    subject.add(expected_value)
    assert subject.result() == expected_value