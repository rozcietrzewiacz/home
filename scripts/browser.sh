#!/bin/bash
/usr/bin/pgrep chrom >/dev/null && /usr/bin/chromium "$@" || /usr/bin/opera "$@"
