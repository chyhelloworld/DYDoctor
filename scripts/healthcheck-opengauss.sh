#!/bin/sh
cd /usr/local/opengauss
LD_LIBRARY_PATH=/usr/local/opengauss/lib:$LD_LIBRARY_PATH bin/gsql -U omm -W Yudao@2024 -d postgres -c 'SELECT 1' > /dev/null 2>&1
