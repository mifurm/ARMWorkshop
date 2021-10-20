az postgres server-logs list -g [resource_group] -s [server-name] --query '[].{Name:name}' -o tsv |xargs -I {} az postgres server-logs download -g [resource_group] -s [server-name] -n {}
