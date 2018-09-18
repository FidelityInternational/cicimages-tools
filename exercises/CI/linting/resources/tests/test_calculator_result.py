from calculator import Calculator


def test_is_0_by_default():
    assert Calculator().result() == 0
    
    