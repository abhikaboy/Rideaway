const { MongoClient } = require("mongodb");

console.log(process.env.ATLAS_URI);

const connectionString = `mongodb+srv://dbadmin:${process.env.ATLAS_URI}@cluster0.zpr86kq.mongodb.net/?retryWrites=true&w=majority`;

const client = new MongoClient(connectionString, {
	useNewUrlParser: true,
	useUnifiedTopology: true,
});

let dbConnection;
module.exports = {
	connectToServer: function (callback) {
		client.connect(function (err, db) {
			if (err || !db) {
				return callback(err);
			}

			dbConnection = db.db("rides");
			dbConnection
				.collection("requests")
				.createIndex(
					{ createdAt: 1 },
					{ expireAfterSeconds: 3600 * 6 },
				);
			console.log("Successfully connected to MongoDB.");

			return callback();
		});
	},

	getDb: function () {
		return dbConnection;
	},
};
