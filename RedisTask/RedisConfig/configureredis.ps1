param (
	[string]$redisFolder,
	[string]$serviceName,

	[string]$isSentinel,
	[string]$sentinelMasterIP,
	[string]$sentinelMasterPort,
	[string]$sentinelQuorum,
	[string]$sentinelDownAfter,
	[string]$sentinelFailover,

	[string]$port,
	[string]$tcpBacklog,
	[string]$bindIp,
	[string]$timeOut,
	[string]$tcpKeepAlive,

	[string]$logLevel,
	[string]$logfile,
	[string]$syslogEnabled,
	[string]$syslogName,
	
	[string]$amountOfDbs,
	[string]$maxClients,
	
	[string]$isSlave,
	[string]$masterIp,
	[string]$masterPort,
	[string]$masterAuth,
	[string]$slaveServeStaleData,
	[string]$slaveIsReadOnly,
	[string]$slavePriority,
	
	[string]$disklessReplication,
	[string]$disklessReplicationDelay,
	[string]$replicationPingSlavePeriod,
	[string]$replicationTimeout,
	[string]$replicationTcpNoDelay,
	[string]$replicationBacklogSize,
	[string]$replicationBacklogTtl,

	[string]$requireAuth,
	[string]$redisPassword
)

function Add-ConfigParameter([string]$parameterValue, $parameterName) {
	
	$configurationLine = ""
	if ($parameterValue.Trim() -ne "") {
		$configurationLine += "$parameterName $parameterValue`r`n"
	} 

	return $configurationLine
}

## --------------------------------------------------------------------------------------
## Check parameters and defaults
## --------------------------------------------------------------------------------------

$dbAmount = 16

if ($port -eq "") { $port = "6379" }
if ($tcpBacklog -eq "") { $tcpBacklog = "511" }
if ($timeOut -eq "") { $timeOut = "0" }
if ($tcpKeepAlive -eq "") {$tcpKeepAlive = "0" }
if ($logLevel -eq "") {$logLevel = "notice" }
if ($amountOfDbs -ne "") { $dbAmount = [System.Convert]::ToInt32($amountOfDbs) }
if ($disklessReplicationDelay -eq "") { $disklessReplicationDelay = "5" }
if ($replicationPingSlavePeriod -eq "") { $replicationPingSlavePeriod = "10" }
if ($replicationTimeout -eq "") { $replicationTimeout = 60 }
if ($replicationBacklogSize -eq "") { $replicationBacklogSize = "1mb" }
if ($replicationBacklogTtl -eq "") { $replicationBacklogTtl = "3600" }
if ($slavePriority -eq "") { $slavePriority = "100" }
if ($maxClients -eq "") { $maxClients = "10000" }

$isSentinel = $isSentinel.ToLower() -eq "true"
$isSlave = $isSlave.ToLower() -eq "true"
$syslogEnabled = $syslogEnabled.ToLower() -eq "true"
$slaveServeStaleData = $slaveServeStaleData.ToLower() -eq "true"
$slaveIsReadOnly = $slaveIsReadOnly.ToLower() -eq "true"
$disklessReplication = $disklessReplication.ToLower() -eq "true"
$replicationTcpNoDelay = $replicationTcpNoDelay.ToLower() -eq "true"
$requireAuth = $requireAuth.ToLower() -eq "true"

$configFileName = "$serviceName.conf"
$configFile = Join-Path $redisFolder $configFileName
$redisServiceExe = Join-Path $redisFolder "redis-server.exe"

## --------------------------------------------------------------------------------------
## Create config file
## --------------------------------------------------------------------------------------


$configuration = ""
$configuration += Add-ConfigParameter $port -parameterName "port"	
$configuration += Add-ConfigParameter $bindIp -parameterName "bind"	
$configuration += Add-ConfigParameter "dump_$serviceName.rdb" -parameterName "dbfilename"	
$configuration += Add-ConfigParameter "./" -parameterName "dir"	
$configuration += Add-ConfigParameter $logLevel -parameterName "loglevel"	
$configuration += Add-ConfigParameter $logfile -parameterName "logfile"	

if ($syslogEnabled -eq $true) {

	$configuration += Add-ConfigParameter "yes" -parameterName "syslog-enabled"	
	$configuration += Add-ConfigParameter $syslogName -parameterName "syslog-ident"
}

if ($isSentinel -eq $true) {
	
	$configuration += Add-ConfigParameter "$sentinelMasterIp $sentinelMasterPort $sentinelQuorum" -parameterName "sentinel monitor redismaster"	
	$configuration += Add-ConfigParameter $sentinelDownAfter -parameterName "sentinel down-after-milliseconds redismaster"
	$configuration += Add-ConfigParameter $sentinelFailover -parameterName "sentinel failover-timeout redismaster"
}

if ($isSentinel -ne $true) {
	
	$configuration += Add-ConfigParameter $timeout -parameterName "timeout"	
	$configuration += Add-ConfigParameter $tcpBacklog -parameterName "tcp-backlog"
	$configuration += Add-ConfigParameter $tcpKeepAlive -parameterName "tcp-keepalive"	
	$configuration += Add-ConfigParameter $dbAmount -parameterName "databases"
	$configuration += Add-ConfigParameter "900 1" -parameterName "save"	
	$configuration += Add-ConfigParameter "300 10" -parameterName "save"
	$configuration += Add-ConfigParameter "60 10000" -parameterName "save"
	$configuration += Add-ConfigParameter "yes" -parameterName "stop-writes-on-bgsave-error"
	$configuration += Add-ConfigParameter "yes" -parameterName "rdbcompression"
	$configuration += Add-ConfigParameter "yes" -parameterName "rdbchecksum"
	$configuration += Add-ConfigParameter $maxClients -parameterName "maxclients"
}

if ($isSlave -eq $true){
	
	$configuration += Add-ConfigParameter "$masterIp $masterPort" -parameterName "slaveof"	
	$configuration += Add-ConfigParameter $masterAuth -parameterName "masterauth"
	
	if ($slaveServeStaleData -eq $true) {
		$configuration += Add-ConfigParameter "yes" -parameterName "slave-serve-stale-data"
	} else {
		$configuration += Add-ConfigParameter "no" -parameterName "slave-serve-stale-data"
	}
		
	if ($slaveIsReadOnly -eq $true) {
		$configuration += Add-ConfigParameter "yes" -parameterName "slave-read-only"
	} else {
		$configuration += Add-ConfigParameter "no" -parameterName "slave-read-only"
	}
}

if ($disklessReplication -eq $true) {
	$configuration += Add-ConfigParameter "yes" -parameterName "repl-diskless-sync"
	$configuration += Add-ConfigParameter $disklessReplicationDelay -parameterName "repl-diskless-sync-delay"
} else {
	$configuration += Add-ConfigParameter "no" -parameterName "repl-diskless-sync"
}

$configuration += Add-ConfigParameter $replicationPingSlavePeriod -parameterName "repl-ping-slave-period"
$configuration += Add-ConfigParameter $replicationTimeout -parameterName "repl-timeout"

if ($replicationTcpNoDelay -eq $true) {
	$configuration += Add-ConfigParameter "yes" -parameterName "repl-disable-tcp-nodelay"
} else {
	$configuration += Add-ConfigParameter "no" -parameterName "repl-disable-tcp-nodelay"
}

$configuration += Add-ConfigParameter $replicationBacklogSize -parameterName "repl-backlog-size"
$configuration += Add-ConfigParameter $replicationBacklogTtl -parameterName "repl-backlog-ttl"
$configuration += Add-ConfigParameter $slavePriority -parameterName "slave-priority"

if ($requireAuth -eq $true) {
	$configuration += Add-ConfigParameter $redisPassword -parameterName "requirepass"
}

Write-Host "Creating config file $configFile"
New-Item $configFile -type file -force -value $configuration

## --------------------------------------------------------------------------------------
## Install Service
## --------------------------------------------------------------------------------------

$redisService = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

# Create win service if needed
if (!$redisService) {
	
	if($isSentinel -eq $true) {
		Write-Host "Creating sentinel service $serviceName"
		& $redisServiceExe --service-install --service-name $serviceName $configFile --sentinel | Write-Host
	} else {
		Write-Host "Creating service $serviceName"
		& $redisServiceExe --service-install --service-name $serviceName $configFile | Write-Host
	}

	$redisService = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
}

if (!$redisService) {
	Write-Error "$redisService not found!"		
	exit 1
}

if ($redisService.Status -eq "Running") {

	Stop-Service $serviceName -Force
	$redisService.WaitForStatus('Stopped', '00:01:00')
	Write-Output "Service $serviceName stopped."
}

Start-Service $serviceName
$redisService.WaitForStatus('Running', '00:01:00')
Write-Output "Started $serviceName"
