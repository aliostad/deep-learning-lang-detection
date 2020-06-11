#!/usr/bin/env python
# coding=utf-8

from pytest import fixture, raises

from json_config.main import AutoConfigBase

CONFIG = 'config.json'


class AutoSave(AutoConfigBase):
    def serialize(self):
        return str(dict(self))


@fixture
def auto_save(tmpdir):
    """:type tmpdir: py._path.local.LocalPath"""

    return AutoSave(config_file=tmpdir.join(CONFIG).strpath)


def test_misusing_manual_save_raises(auto_save):
    auto_save['this']['is']['a']['test'] = {}

    with raises(RuntimeError):
        auto_save['this']['is'].save()
