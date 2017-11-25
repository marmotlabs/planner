#!/usr/bin/env bash
timestamp=$(date +%Y%m%d%H%M%S)

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

touch ${DIR}/main/resources/db/migration/V${timestamp}__$1.sql
