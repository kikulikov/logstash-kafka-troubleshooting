#!/usr/bin/env bash
set -o pipefail
set -eu

docker-compose down
sleep 5s

docker-compose up -d
sleep 50s

kafka-topics --bootstrap-server localhost:3201 --create --topic logstash_logs_rep3_sync2 \
--replication-factor 3 --partitions 5 --config min.insync.replicas=2

kafka-topics --bootstrap-server localhost:3201 --create --topic logstash_logs_rep3_sync3 \
--replication-factor 3 --partitions 5 --config min.insync.replicas=3

echo ""
echo "Useful commands"
echo "  kafka-topics --list --bootstrap-server localhost:3201"
echo "  kafka-console-consumer --bootstrap-server localhost:3201 --topic logstash_logs_rep3_sync2"
echo "  kafka-console-consumer --bootstrap-server localhost:3201 --topic logstash_logs_rep3_sync3"
echo ""

docker-compose logs -f logstash
