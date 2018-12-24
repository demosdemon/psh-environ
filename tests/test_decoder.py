# -*- coding: utf-8 -*-
import binascii
import json

import pytest
from psh_environ.decoder import decode_base64_json


@pytest.mark.parametrize(
    ("given", "expected"),
    [
        (b"eyJ0ZXN0IjogdHJ1ZX0K", {"test": True}),
        ("e30=", {}),
        (None, None),
        pytest.param(
            "invalid string", None, marks=pytest.mark.xfail(raises=binascii.Error)
        ),
        pytest.param(
            "aW52YWxpZCBzdHJpbmc=",
            None,
            marks=pytest.mark.xfail(raises=json.JSONDecodeError),
        ),
    ],
)
def test_decode_base64_json(given, expected):
    actual = decode_base64_json(given)
    assert actual == expected
