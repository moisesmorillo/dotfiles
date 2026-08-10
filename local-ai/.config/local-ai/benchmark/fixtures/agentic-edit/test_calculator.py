import unittest

from calculator import percentage


class PercentageTest(unittest.TestCase):
    def test_percentage(self) -> None:
        self.assertEqual(percentage(200, 50), 25)

    def test_zero_total(self) -> None:
        self.assertEqual(percentage(0, 0), 0)


if __name__ == "__main__":
    unittest.main()
