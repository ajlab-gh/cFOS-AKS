#!/bin/bash
#
cfos_license_input_file="FGVM08TM23005000.lic"
[[ -f $cfos_license_input_file ]] || echo $cfos_license_input_file does not exist
file="manifests/base/license.yaml"
licensestring=$(sed '1d;$d' $cfos_license_input_file | tr -d '\n')
cat <<EOF >$file
---
apiVersion: v1
kind: ConfigMap
metadata:
    name: cfos-license
    labels:
        app: cfos
        category: license
data:
    license: |
        -----BEGIN FGT VM LICENSE-----
        $licensestring
        -----END FGT VM LICENSE-----
EOF
