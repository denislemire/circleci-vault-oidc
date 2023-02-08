listener "tcp" {
	address = "0.0.0.0:8200"
	tls_disable = "false"
	tls_cert_file = "/etc/letsencrypt/live/vault.generic.business/fullchain.pem"
	tls_key_file = "/etc/letsencrypt/live/vault.generic.business/privkey.pem"
}

storage "raft" {
	path="/vault/file"
	node_id="raft_node1"
}

plugin_directory="/vault/plugins"
cluster_addr = "http://127.0.0.1:8201"
disable_mlock = "true"
ui = "true"
