#!/bin/bash

# Copyright (C) 2017 Red Hat, Inc.

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

if [[ $CITELLUS_LIVE = 0 ]]; then
  echo "works on live-system only" >&2
  exit 2
fi

yum check-update 2> /dev/null
update_check=$?

if [[ $update_check -eq 100 ]]; then
    echo "there are available uninstalled upgrades" >&2
    exit 1
elif [[ $update_check -ne 0 ]]; then
    echo "failed to check available updates" >&2
    exit 1
fi
