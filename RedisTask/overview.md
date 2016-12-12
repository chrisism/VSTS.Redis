# Redis Configuration (VSTS task)
Tasks for VSTS/TFS to configure your Redis instances.

Are these VSTS extensions helping you? 

[![](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=BSMTZP9VKP8QN)

### Details

Redis is an open source (BSD licensed), in-memory data structure store, used as a database, cache and message broker. It supports data structures such as strings, hashes, lists, sets, sorted sets with range queries, bitmaps, hyperloglogs and geospatial indexes with radius queries. Redis has built-in replication, Lua scripting, LRU eviction, transactions and different levels of on-disk persistence, and provides high availability via Redis Sentinel and automatic partitioning with Redis Cluster. 
With these tasks for VSTS/TFS you can configure your Redis instances. You can configure either single instances or sentinel instances. Supports master/slave options and other extended configurations.

### Configure instance
### Options

* **Redis folder:** Folder where redis is installed.
* **Service name:** The name of the service instance of Redis.
* **Port:** Accept connections on the specified port, default is 6379. If port 0 is specified Redis will not listen on a TCP socket.
* **IP:** By default Redis listens for connections from all the network interfaces available on the server. It is possible to listen to just one or multiple interfaces by entering one or more IP addresses. Examples: * 192.168.1.100 10.0.0.1 * 127.0.0.1
* **Use authentication:** Require clients to issue AUTH <PASSWORD> before processing any other commands. This might be useful in environments in which you do not trust others with access to the host running redis-server.
* **Password:** Require clients to issue AUTH <PASSWORD> before processing any other commands. This might be useful in environments in which you do not trust others with access to the host running redis-server.
* **Run as sentinel:** Run this instance as a sentinel
* **Master IP:** Tells Sentinel to monitor this master on this IP address.
* **Master Port:** Tells Sentinel to monitor this master on this port number.
* **Quorum:** "Amount of Sentinels that is needed to indicate master changes.
* **Down period:** Number of milliseconds the master (or any attached slave or sentinel) should be unreachable (as in, not acceptable reply to PING, continuously, for the specified period) in order to consider it in S_DOWN state (Subjectively Down). Default is 30 seconds.
* **Failover-timeout:** Specifies the failover timeout in milliseconds. It is used in many ways: The time needed to re-start a failover after a previous failover was already tried against the same master by a given Sentinel, is two times the failover timeout. The time needed for a slave replicating to a wrong master according to a Sentinel current configuration, to be forced to replicate with the right master, is exactly the failover timeout (counting since the moment a Sentinel detected the misconfiguration). The time needed to cancel a failover that is already in progress but did not produced any configuration change (SLAVEOF NO ONE yet not acknowledged by the promoted slave). The maximum time a failover in progress waits for all the slaves to be reconfigured as slaves of the new master. However even after this time the slaves will be reconfigured by the Sentinels anyway, but not with the exact parallel-syncs progression as specified. Default is 3 minutes.
* **Number of databases:** Set the number of databases. The default database is DB 0.
* **Max clients:** Set the max number of connected clients at the same time. By default this limit is set to 10000 clients, however if the Redis server is not able to configure the process file limit to allow for the specified limit the max number of allowed clients is set to the current file limit minus 32 (as Redis reserves a few file descriptors for internal uses). Once the limit is reached Redis will close all the new connections sending an error 'max number of clients reached'.
* **Timeout:** Close the connection after a client is idle for N seconds (0 to disable).
* **TCP backlog:** In high requests-per-second environments you need an high backlog in order to avoid slow clients connections issues. (Default 511)
* **TCP keepalive:** If non-zero, use SO_KEEPALIVE to send TCP ACKs to clients in absence of communication. A reasonable value for this option is 60 seconds. This is useful for two reasons: 1. Detect dead peers. 2. Take the connection alive from the point of view of network equipment in the middle.
* **Log level:** Specify the server verbosity level. This can be one of: 
** debug (a lot of information, useful for development/testing) 
** verbose (many rarely useful info, but not a mess like the debug level)
** notice (moderately verbose, what you want in production probably) 
** warning (only very important / critical messages are logged)
* **Log filename:** Specify the log file name. Also 'stdout' can be used to force Redis to log on the standard output.
* **Use Windows EventLog:** Option to enable logging to the Windows EventLog. Optionally update the other syslog parameters to suit your needs. If Redis is installed and launched as a Windows Service, this will automatically be enabled.
* **"EventLog source name:** Specify the source name of the events in the Windows Application log.
* **Configure instance as slave:** Make this Redis instance a copy of another Redis server.
* **IP of master:** IP address of the master Redis server.
* **Port of master:** Port of the master Redis server.
* **Master password:** If the master is password protected it is possible to tell the slave to authenticate before starting the replication synchronization process, otherwise the master will refuse the slave request. Leave empty if no password on the master.
* **Keep serving stale data:** When a slave loses its connection with the master, or when the replication is still in progress, the slave can act in two different ways: 1. if set to 'yes' (the default) the slave will still reply to client requests, possibly with out of date data, or the data set may just be empty if this is the first synchronization. 2. if set to 'no' the slave will reply with an error \"SYNC with master in progress\" to all the kind of commands but to INFO and SLAVEOF.
* **Use read-only mode:** You can configure a slave instance to accept writes or not. Writing against a slave instance may be useful to store some ephemeral data (because data written on a slave will be easily deleted after resync with the master) but may also cause problems if clients are writing to it because of a misconfiguration.
* **Priority:** An integer number published by Redis in the INFO output. It is used by Redis Sentinel in order to select a slave to promote into a master if the master is no longer working correctly. A slave with a low priority number is considered better for promotion. Priority 0 marks the slave as not able to perform the role of master, so a slave with priority of 0 will never be selected by Redis Sentinel for promotion.
* **Use diskless replication:** When diskless replication is used, the master waits a configurable amount of time (in seconds) before starting the transfer in the hope that multiple slaves will arrive and the transfer can be parallelized.
* **Diskless replication delay:** When diskless replication is enabled, it is possible to configure the delay the server waits in order to spawn the child that trnasfers the RDB via socket to the slaves. This is important since once the transfer starts, it is not possible to serve new slaves arriving, that will be queued for the next RDB transfer, so the server waits a delay in order to let more slaves arrive. The delay is specified in seconds, and by default is 5 seconds. To disable it entirely just set it to 0 seconds and the transfer will start ASAP.
* **PING period:** Slaves send PINGs to server in a predefined interval. It's possible to change this interval with the repl_ping_slave_period option. The default value is 10 seconds.
* **Timeout:** This following option sets the replication timeout for: 1. Bulk transfer I/O during SYNC, from the point of view of slave. 2. Master timeout from the point of view of slaves (data, pings). 3. Slave timeout from the point of view of masters (REPLCONF ACK pings)
* **Disable TCP_NODELAY:** "Disable TCP_NODELAY on the slave socket after SYNC? If you select 'yes' Redis will use a smaller number of TCP packets and less bandwidth to send data to slaves. But this can add a delay for the data to appear on the slave side, up to 40 milliseconds with Linux kernels using a default configuration. If you select 'no' the delay for data to appear on the slave side will be reduced but more bandwidth will be used for replication.
* **Backlog size:** Set the replication backlog size. The backlog is a buffer that accumulates slave data when slaves are disconnected for some time, so that when a slave wants to reconnect again, often a full resync is not needed, but a partial resync is enough, just passing the portion of data the slave missed while disconnected. The bigger the replication backlog, the longer the time the slave can be disconnected and later be able to perform a partial resynchronization. The backlog is only allocated once there is at least a slave connected.
* **Backlog TTL:** After a master has no longer connected slaves for some time, the backlog will be freed. The following option configures the amount of seconds that need to elapse, starting from the time the last slave disconnected, for the backlog buffer to be freed. A value of 0 means to never release the backlog.
