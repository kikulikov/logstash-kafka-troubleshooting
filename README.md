# Logstash-Kafka Troubleshooting

## Failing Scenario

### Run the bundle

```bash
./run.sh
```

### Run Kafka console consumer for the topic with min.insync.replicas=2

```bash
kafka-console-consumer --bootstrap-server localhost:3201 --topic logstash_logs_rep3_sync2

{"clock":1,"@timestamp":"2020-12-04T17:14:26.424Z","host":"07a20487bcac","@version":"1"}
{"clock":2,"@timestamp":"2020-12-04T17:14:28.403Z","host":"07a20487bcac","@version":"1"}
{"clock":3,"@timestamp":"2020-12-04T17:14:30.404Z","host":"07a20487bcac","@version":"1"}
```

### Run Kafka console consumer for the topic with min.insync.replicas=3

```bash
kafka-console-consumer --bootstrap-server localhost:3201 --topic logstash_logs_rep3_sync3

{"clock":1,"@timestamp":"2020-12-04T17:14:26.424Z","host":"07a20487bcac","@version":"1"}
{"clock":2,"@timestamp":"2020-12-04T17:14:28.403Z","host":"07a20487bcac","@version":"1"}
{"clock":3,"@timestamp":"2020-12-04T17:14:30.404Z","host":"07a20487bcac","@version":"1"}
```

### Leave consumers running

### Observe topics consumption. The consumers should be in sync

### Kill one of the Kafka brokers

```bash
docker kill kafka2
```

### Logstash starts to error

```bash
# logstash     | [WARN ] 2020-12-04 17:01:13.921 [kafka-producer-network-thread | producer-2] Sender - [Producer clientId=producer-2] Got error produce response with correlation id 1065 on topic-partition logstash_logs_rep3_sync3-1, retrying (2147483243 attempts left). Error: NOT_ENOUGH_REPLICAS
# logstash     | [WARN ] 2020-12-04 17:01:13.946 [kafka-producer-network-thread | producer-2] Sender - [Producer clientId=producer-2] Got error produce response with correlation id 1066 on topic-partition logstash_logs_rep3_sync3-0, retrying (2147483248 attempts left). Error: NOT_ENOUGH_REPLICAS
```

Which makes sense for topic `logstash_logs_rep3_sync3 (min.insync.replicas=3)`.

### What's wrong

BUT there are no new messages neither in `logstash_logs_rep3_sync3 (min.insync.replicas=3)`
nor in `logstash_logs_rep3_sync2 (min.insync.replicas=2)`. Logstash doesn't produce any messages at all from this point despite the fact that there are healthy partitions and topics.
