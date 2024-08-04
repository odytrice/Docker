docker build -t odytrice/cassandra:5.0 -t odytrice/cassandra:latest cassandra
docker push --all-tags odytrice/cassandra

docker build -t odytrice/kafka:3.7.0 -t odytrice/kafka:latest kafka
docker push --all-tags odytrice/kafka

docker build -t odytrice/github-runner:2.317.0 -t odytrice/github-runner:latest github-runner
docker push --all-tags odytrice/github-runner