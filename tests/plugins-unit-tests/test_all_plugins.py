#!/usr/bin/env python
# encoding: utf-8
#
# Description: This UT run all scripts to validate the rules/tests created
#
# Copyright (C) 2017  Pablo Iranzo Gómez (Pablo.Iranzo@redhat.com)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import os
import subprocess
from unittest import TestCase
import tempfile
import shutil

from citellus import citellus

testplugins = os.path.join(citellus.citellusdir, 'testplugins')
plugins = os.path.join(citellus.citellusdir, 'plugins')
folder = os.path.join(os.path.abspath(os.path.dirname(__file__)), 'setup')
uttest = citellus.findplugins(folders=[folder])
citplugs = citellus.findplugins(folders=[plugins])

# Setup commands and expected return codes
rcs = {"pass": citellus.RC_OKAY,
       "fail": citellus.RC_FAILED,
       "skipped": citellus.RC_SKIPPED}


class CitellusTest(TestCase):
    def test_pass(self):
        tmpdir = tempfile.mkdtemp(prefix='citellus-tmp')

        # Setup folder for all tests
        testtype = 'pass'
        for test in uttest:
            subprocess.call([test, test, testtype, tmpdir])

        # Run citellus once against them
        results = citellus.docitellus(path=tmpdir, plugins=citplugs)

        # Remove tmp folder
        shutil.rmtree(tmpdir)

        # Process plugin output from multiple plugins
        new_dict = []
        for item in results:
            new_dict.append(item['result']['rc'])

        assert sorted(set(new_dict)) == [0, 1, 2]
