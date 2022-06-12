const express = require("express");
// The router will be added as a middleware and will take control of requests starting with path /listings.
const userRoutes = express.Router();

// This will help us connect to the database
const dbo = require("../db/conn");
const { ObjectID } = require("bson");

const getUserById = async (id) => {
	const dbConnect = dbo.getDb();
	return await dbConnect.collection("users").findOne({ _id: ObjectID(id) });
};
// This section will help you get a list of all the records.
userRoutes.route("/users").get(async function (req, res) {
	const dbConnect = dbo.getDb();
	const { id } = req.query;
	console.log(id);
	console.log(typeof id);
	if (typeof id != "undefined") {
		console.log("looking for a specific user");
		await getUserById(id).then((response) => {
			res.json(response);
		});
	} else {
		console.log("listing all users");
		dbConnect
			.collection("users")
			.find({})
			.limit(50)
			.toArray(function (err, result) {
				if (err) {
					res.status(400).send("Error fetching listings!");
				} else {
					res.json(result);
				}
			});
	}
});

userRoutes.route("/users/login").post(async (req, res) => {
	const dbConnect = dbo.getDb();
	const { code, number } = req.query;
	console.log(code);
	if (typeof code == "undefined") {
		res.status(400).send("No code given");
	}
	const codes = await dbConnect
		.collection("codes")
		.countDocuments({ code: code });
	console.log(codes);
	if (codes > 0) {
		await dbConnect.collection("codes").deleteOne({ code: code });
		const userId = ObjectID();
		await dbConnect.collection("users").insertOne({
			_id: userId,
			incommingRQ: true,
			number: number,
		});
		res.status(200).send(userId);
	} else {
		res.status(400).send("invalid code");
	}
});
userRoutes.route("/users/create").post(async (req, res) => {
	const dbConnect = dbo.getDb();
	const { number } = req.query;
	if (number.length != 10) {
		res.status(400).send("Please enter a valid phone number");
	}
	const accountSid = process.env.TWILIO_ACCOUNT_SID;
	const authToken = process.env.TWILIO_AUTH_TOKEN;
	const client = require("twilio")(accountSid, authToken);
	const code =
		Math.random().toString(36).substring(2, 5) +
		Math.random().toString(36).substring(2, 5);
	const userID = ObjectID();
	client.messages
		.create({
			body: code,
			from: "+16096046893",
			to: `+1${number}`,
		})
		.then((response) => {
			res.status(200).send("code sent");
		});
	await dbConnect.collection("codes").insertOne({
		code: code,
		user: userID,
	});
});

module.exports = userRoutes;
