import sys

from unittest import TestCase
from unittest.mock import MagicMock

pygame = MagicMock()
sys.modules["pygame"] = pygame


# from hexoshi import *
import hlib


class TestHexoshi(TestCase):
    pass
