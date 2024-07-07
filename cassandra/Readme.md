# Cassandra Image

This image is based on the [Official Cassandra Image](https://github.com/docker-library/docs/blob/master/cassandra/README.md) as a result, all the existing Configuration Applies


## Additional Environment Variables

- `CASSANDRA_MATERIALIZED_VIEWS_ENABLED`: Enables materialized view creation on this node. Materialized views are considered experimental and are not recommended for production use.

- `CASSANDRA_CONFIG`: Path to cassandra.yaml Default: `/opt/cassandra/cassandra.yaml` Note: Changing this config overrides all previous Cassandra Config
