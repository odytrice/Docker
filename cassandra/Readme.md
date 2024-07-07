# Cassandra

```
_________                                          .___
\_   ___ \_____    ______ ___________    ____    __| _/___________
/    \  \/\__  \  /  ___//  ___/\__  \  /    \  / __ |\_  __ \__  \_
\     \____/ __ \_\___ \ \___ \  / __ \|   |  \/ /_/ | |  | \// __ \_
 \______  (____  /____  >____  >(____  /___|  /\____ | |__|  (____  /
        \/     \/     \/     \/      \/     \/      \/            \/
```

This image is based on the [Official Cassandra Image](https://github.com/docker-library/docs/blob/master/cassandra/README.md) as a result, all the existing Configuration Applies


## Additional Environment Variables

- `CASSANDRA_MATERIALIZED_VIEWS_ENABLED`: Enables materialized view creation on this node. Materialized views are considered experimental and are not recommended for production use.

- `CASSANDRA_CONFIG`: Path to Cassandra config file i.e. `cassandra.yaml` If this file is present in the container, It will override all other settings. Default Path: `/opt/cassandra/cassandra.yaml`
