# Apache Kafka Setup Log

History of how Apache Kafka was installed on this machine as a systemd-managed local broker.

## Timeline

1. Downloaded the Kafka tarball (`kafka_2.13-4.3.1.tgz`, 130M) from the Apache mirror [dlcdn.apache.org/kafka/](https://dlcdn.apache.org/kafka/) into the repo, then moved it to `~/opt`.

2. Extracted to `~/opt/kafka_2.13-4.3.1`:
```bash
cd ~/opt && tar -xzf kafka_2.13-4.3.1.tgz
```

3. Persisted log data dir
Edited `~/opt/kafka_2.13-4.3.1/config/server.properties`:
```properties
log.dirs=/home/xlwp/kafka-data
```
(changed from the stock `/tmp/kraft-combined-logs`).

4. Formatted KRaft storage (required once before first start; single node = `--standalone`):
```bash
UUID=$(~/opt/kafka_2.13-4.3.1/bin/kafka-storage.sh random-uuid)
~/opt/kafka_2.13-4.3.1/bin/kafka-storage.sh format --standalone -t "$UUID" \
  -c ~/opt/kafka_2.13-4.3.1/config/server.properties
```

5. systemd user service
Created `config/systemd-user/kafka.service` in the repo, symlinked to `~/.config/systemd/user/kafka.service`:
```bash
ln -sf $REPO/config/systemd-user/kafka.service ~/.config/systemd/user/kafka.service
systemctl --user daemon-reload
systemctl --user enable --now kafka.service
```

6. Environment variables
Added to `~/.bashrc`:
```bash
export PATH=$PATH:$HOME/opt/kafka_2.13-4.3.1/bin
```

## What's installed

| Component | Location / Version |
|---|---|
| Kafka home | `/home/xlwp/opt/kafka_2.13-4.3.1` |
| Version | `2.13-4.3.1` (Java 21, OpenJDK 21.0.12) |
| Mode | KRaft single node (`broker,controller`, no ZooKeeper) |
| Listeners | `PLAINTEXT://:9092` (broker), `CONTROLLER://:9093` |
| Log data | `/home/xlwp/kafka-data` |
| Service | `kafka.service` (systemd user unit) |

## Daily usage

```bash
systemctl --user status kafka.service   # check status
systemctl --user restart kafka.service  # restart
systemctl --user stop kafka.service     # stop
journalctl --user -u kafka.service -f   # follow logs
```

Use the `kafka-topics.sh`, `kafka-console-producer.sh`, `kafka-console-consumer.sh` commands (on `PATH` via `~/.bashrc`).

### Quick smoke test

```bash
kafka-topics.sh --bootstrap-server localhost:9092 --create --topic test
echo "hello" | kafka-console-producer.sh --bootstrap-server localhost:9092 --topic test
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
```

## Notes

- Runs as a **user-level** systemd service (no sudo); requires `systemctl --user` and a running user session.
- Memory capped at 1G heap via `KAFKA_HEAP_OPTS` in the unit file.
- The unit file is managed in this repo; re-run `setup/setup-symlinks.sh`-style link or `ln -sf` if it's missing after a fresh clone.
