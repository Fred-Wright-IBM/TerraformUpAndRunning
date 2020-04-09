#!/bin/bash

cat > index.html <<EOF
<h1>Hello, World</h1>
<p>Dynamodb Table Name: ${dynamodb_table_name}</p>
EOF

nohup busybox httpd -f -p ${server_port} &
