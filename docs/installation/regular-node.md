# Regular Node Installation

This guide will help you set up a regular KalyChain node that syncs with the network and maintains blockchain data.

> **Prerequisites:** This guide assumes you have completed the [Server Setup](server-setup.md) guide for security hardening.

> **ℹ️ Note:** Regular nodes do not participate in consensus or earn rewards, but they help secure the network by maintaining a copy of the blockchain.

## Getting Started

Login to your server via ssh as a non-root user

```bash
ssh kaly@node.ip.address
```
Install OpenJDK-21

```bash
sudo apt install openjdk-21-jre-headless -y
```
Download the binary and clean up the zip file

```bash
wget https://github.com/KalyCoinProject/kalychain/releases/download/25.7.0/besu-25.7.0.zip
sudo apt install unzip -y && unzip besu-25.7.0.zip
sudo mv besu-25.7.0 kaly && rm besu-25.7.0.zip
```
Make a data directory

```bash
mkdir node && mkdir node/data
```
{% hint style="info" %}
In this example the node/data directories are where the blockchain and genesis files will be stored. You can choose to store these files in other locations based on your setup. If you change the location of these files then you will need to update the paths when starting the node.
{% endhint %}

Copy the genesis file to the new node directory. You can find the _genesis.json_ file in the **configs** directory of this repo.

```bash
cp configs/regular/genesis.json node/genesis.json
```

## Start the KalyChain node.

In this section, a daemon will be created to start the KalyChain node in case of server crashes, unexpected restarts, etc.

{% hint style="info" %} :fire: **Pro Tip** We have included a bash script named *start_node.sh* to run these steps for you, please review it and make any changes to paths as needed for your setup. Make the file exicutable by running *chmod +x start_node.sh*
{% endhint %}

The first thing is to create the file for the besu service. To do this, the following steps will be followed.

```sh
cd /lib/systemd/system
sudo nano kalynode.service
```

The following variables will be put in this file: `StartLimitBurst` and `RestartSec` will cause it to make 5 restart attempts every 10s and if it fails at all it will stop trying. 

```service
[Unit]
Description=Kaly Node Service
After=network.target
StartLimitBurst=5
StartLimitIntervalSec=200

[Service]
WorkingDirectory=/home/$USER/node/
Type=simple
User=$USER
Group=$USER
ExecStart=/home/$USER/node/../kaly/bin/besu --config-file=/home/$USER/node-install/configs/regular/config.toml
Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target
```

Once the _kalynode.services_ file has been saved, this service is started. Run the following commands.

To let the system know that there is a new daemon that must be started at every boot, the following will be executed:

```sh
sudo systemctl daemon-reload
sudo systemctl enable kalynode.service
```

To start the service run the following command.

```sh
sudo systemctl start kalynode.service
```

Finally, to ensure that the service is correctly started it will run:

```sh
sudo systemctl status kalynode.service
```

Getting a result like this.

```sh
● kaly.service - Kaly Node Service
     Loaded: loaded (/etc/systemd/system/kaly.service; disabled; vendor preset: enabled)
     Active: active (running) since Fri 2023-03-24 19:34:07 UTC; 6 days ago
   Main PID: 4543 (java)
      Tasks: 80 (limit: 18979)
     Memory: 1.1G
     CGroup: /system.slice/kaly.service
             └─4543 java -Dvertx.disableFileCPResolving=true -Dbesu.home=/home/dev/besu -Dlog4j.shutdownHookEnabled=false -Dlog4j2.formatMsgNoLookups=true -Djava.util.logging.manager=org.apache.logging.l>

Mar 31 00:27:37 sea-sm5038md-h24trf-2-21 besu[4543]: 2023-03-31 00:27:37.023+00:00 | EthScheduler-Workers-0 | INFO  | PersistBlockTask | Imported 268,228 / 0 tx / 0 om / 0 (0.0%) gas / (0x8d24d427e3ed30>
Mar 31 00:27:39 sea-sm5038md-h24trf-2-21 besu[4543]: 2023-03-31 00:27:39.005+00:00 | EthScheduler-Workers-0 | INFO  | PersistBlockTask | Imported 268,229 / 0 tx / 0 om / 0 (0.0%) gas / (0xff9342efd96c96>
Mar 31 00:27:41 sea-sm5038md-h24trf-2-21 besu[4543]: 2023-03-31 00:27:41.035+00:00 | EthScheduler-Workers-0 | INFO  | PersistBlockTask | Imported 268,230 / 0 tx / 0 om / 0 (0.0%) gas / (0xd72bb1107f282f>
Mar 31 00:27:43 sea-sm5038md-h24trf-2-21 besu[4543]: 2023-03-31 00:27:43.036+00:00 | EthScheduler-Workers-0 | INFO  | PersistBlockTask | Imported 268,231 / 0 tx / 0 om / 0 (0.0%) gas / (0xa0f8820b82a734>
Mar 31 00:27:45 sea-sm5038md-h24trf-2-21 besu[4543]: 2023-03-31 00:27:45.024+00:00 | EthScheduler-Workers-0 | INFO  | PersistBlockTask | Imported 268,232 / 0 tx / 0 om / 0 (0.0%) gas / (0x4f8434013a19cf>
Mar 31 00:27:47 sea-sm5038md-h24trf-2-21 besu[4543]: 2023-03-31 00:27:47.006+00:00 | EthScheduler-Workers-0 | INFO  | PersistBlockTask | Imported 268,233 / 0 tx / 0 om / 0 (0.0%) gas / (0xd51527a085ac1a>
Mar 31 00:27:49 sea-sm5038md-h24trf-2-21 besu[4543]: 2023-03-31 00:27:49.035+00:00 | EthScheduler-Workers-0 | INFO  | PersistBlockTask | Imported 268,234 / 0 tx / 0 om / 0 (0.0%) gas / (0x417fbca71bf666>
Mar 31 00:27:51 sea-sm5038md-h24trf-2-21 besu[4543]: 2023-03-31 00:27:51.036+00:00 | EthScheduler-Workers-0 | INFO  | PersistBlockTask | Imported 268,235 / 0 tx / 0 om / 0 (0.0%) gas / (0x905f30530e8d85>
Mar 31 00:27:53 sea-sm5038md-h24trf-2-21 besu[4543]: 2023-03-31 00:27:53.025+00:00 | EthScheduler-Workers-0 | INFO  | PersistBlockTask | Imported 268,236 / 0 tx / 0 om / 0 (0.0%) gas / (0xbd8759087cca61>
Mar 31 00:27:55 sea-sm5038md-h24trf-2-21 besu[4543]: 2023-03-31 00:27:55.007+00:00 | EthScheduler-Workers-0 | INFO  | PersistBlockTask | Imported 268,237 / 0 tx / 0 om / 0 (0.0%) gas / (0x0869b88844d601>
```

**Optional**

In order to control the Validator logs, KalyChain allows you to [configure your logs](https://besu.hyperledger.org/en/stable/public-networks/how-to/monitor/logging/) thanks to [log4j2](https://logging.apache.org/log4j/2.x/manual/configuration.html), being able to change the format in which you take them out, if you make rotations, if you compress the new files, how many you save and where you save them, etc. To do this, a file called **log-config.xml** is stored in _config_.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="INFO" monitorInterval="5">

  <Properties>
    <Property name="root.log.level">INFO</Property>
  </Properties>

  <Appenders>
    <Console name="Console" target="SYSTEM_OUT">
        <PatternLayout pattern="%d{yyyy-MM-dd HH:mm:ss.SSSZZZ} | %t | %-5level | %c{1} | %msg %throwable{short.message}%n" />
    </Console>
    <RollingFile name="RollingFile" fileName="/kaly/besu/logs/besu.log" filePattern="/kaly/besu/logs/besu-%d{yyyyMMdd}-%i.log.gz" >
        <PatternLayout pattern="%d{yyyy-MM-dd HH:mm:ss.SSSZZZ} | %t | %-5level | %c{1} | %msg %throwable{short.message}%n" />
        <!-- Logs in JSON format
        <PatternLayout alwaysWriteExceptions="false" pattern='{"timestamp":"%d{ISO8601}","container":"${hostName}","level":"%level","thread":"%t","class":"%c{1}","message":"%msg","throwable":"%enc{%throwable}{JSON}"}%n'/>
        -->
      <Policies>
        <OnStartupTriggeringPolicy minSize="10240" />
        <TimeBasedTriggeringPolicy />
        <SizeBasedTriggeringPolicy size="50 MB"/>
      </Policies>
      <DefaultRolloverStrategy max="365" />
    </RollingFile>
  </Appenders>

  <Loggers>
    <Root level="${sys:root.log.level}">
      <AppenderRef ref="Console" />
      <AppenderRef ref="RollingFile" />
    </Root>
  </Loggers>

</Configuration>
```

In this case, the configuration that has been decided on is as follows.

- Both for the logs displayed on the console and for those stored in the rotated files will be the standard (can be changed to _json_ format or other formats allowed by the tool).
- It will generate a rotated log file when
  - The Besu Service is restarted whenever the file size is greater than 10 KB (`OnStartupTriggeringPolicy minSize="10240"`).
  - Once a day (`TimeBasedTriggeringPolicy`).
  - When the log file, if not spent a day, occupies more than 50 MB (`SizeBasedTriggeringPolicy size="50 MB"`).
- You will save 365 log files in a compressed format. Once the 365 files have passed, you will start deleting the first ones you created (`DefaultRolloverStrategy max="365"`).
```

If you use this setup for log rotation:
Add the environment variable `LOG4J_CONFIGURATION_FILE` to the kalynode.service file by adding this line.

```bash
Environment=LOG4J_CONFIGURATION_FILE=/home/$USER/node-install/configs/regular/log-config.xml
```

You can view the log file you have generated with this command.

```sh
tail -f besu.log

```
