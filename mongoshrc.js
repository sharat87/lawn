prompt = function () {
	let host = db.serverStatus().host.split('.')[0];
	host = host.replace(/(-cluster)?-shard-\d+-\d+-\w+$/, "")
	return db.getName() + '@' + host + '> ';
}
