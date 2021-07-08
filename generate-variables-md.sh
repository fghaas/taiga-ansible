#!/bin/bash

exec 1>variables.md

cat <<'EOF'
# Overridable variables defined for `ansible-taiga`
EOF

for role in taiga{,-webserver,-front,-back,-events,-node}; do
    role_defaults_file="roles/$role/defaults/main.yml"
    if [ -e $role_defaults_file ]; then
	echo
	echo "## Variables defined in \`$role\`"
	echo
	echo '```yaml'
	cat $role_defaults_file
	echo
	echo '```'
    fi
done

