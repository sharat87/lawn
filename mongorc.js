load("/Users/shri/.mongohacker.js");

prompt = function () {
	let host = db.serverStatus().host.split('.')[0];
	host = host.replace(/(-cluster)?-shard-\d+-\d+-\w+$/, "")
	return db + '@' + host + '> ';
}

// Pretty print by default.
DBQuery.prototype._prettyShell = true

shellHelper.cs = function () {
	const colls = db.runCommand("listCollections");
	printjson(colls);
};

/**
 * Dump indexes defined in all collections in current database.
 */
function indexDump() {
	const indexes = {};
	for (const collection of db.getCollectionNames()) {
		indexes[collection] = db.getCollection(collection).getIndexes();
	}
	printjson(indexes);
}

function mongorc() {
	load("/Users/shri/.mongorc.js");
}

/**
 * Commands for lookup by id.
 */
shellHelper.org = idFinder("organization");
shellHelper.app = idFinder("application");
shellHelper.act = idFinder("newAction");
shellHelper.user = idFinder("user");
shellHelper.pl = idFinder("plugin");
shellHelper.page = idFinder("newPage");
shellHelper.ds = idFinder("datasource");

function idFinder(collectionName) {
	return function (id) {
		db[collectionName].find({_id: ObjectId(id)}).forEach(doc => {
			printjson(doc);
		});
	};
}
