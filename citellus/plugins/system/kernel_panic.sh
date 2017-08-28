#!/bin/bash

# Copyright (C) 2017   Robin Cernin (rcernin@redhat.com)

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

# Looks for the Kernel Out of Memory, panics and soft locks

journal=( "${CITELLUS_ROOT}/sos_commands/logs/journalctl_--no-pager_--boot" \
          "${CITELLUS_ROOT}/sos_commands/logs/journalctl_--all_--this-boot_--no-pager" )

if [ "x$CITELLUS_LIVE" = "x0" ];  then

  for file in "${journal[@]}"; do
    [[ -f "${file}" ]] && journal_file="${file}"
  done

  if [ -z "${journal_file}" ]; then
    echo "file /sos_commands/logs/journalctl_--no-pager_--boot not found." >&2
    echo "file /sos_commands/logs/journalctl_--all_--this-boot_--no-pager not found." >&2
    exit 2
  fi

  if grep -q "oom-killer" "${journal_file}"; then
    echo "oom-killer detected" >&2
    exit 1
  fi
  if grep -q "soft lockup" "${journal_file}"; then
    echo "soft lockup detected" >&2
    exit 1
  fi
elif [ "x$CITELLUS_LIVE" = "x1" ]; then
  if journalctl -u kernel --no-pager --boot | grep -q "oom-killer"; then
    echo "oom-killer detected" >&2
    exit 1
  fi
  if journalctl -u kernel --no-pager --boot | grep -q "soft lockup"; then
    echo "soft lockup detected" >&2
    exit 1
  fi
fi

