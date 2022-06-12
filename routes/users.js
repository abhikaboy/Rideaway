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
	const { id, password } = req.query;
	console.log(id);
	console.log(typeof id);
	if (typeof id == "undefined") {
		res.status(400).send("No user given");
	}
	const user = await getUserById(id);
	if (user == null) res.status(400).send("No user found");
	if (user.password == password)
		res.status(200).send("User Logged In Will send JWT later lol");
	else {
		res.status(400).send("invalid password");
	}
});
userRoutes.route("/users/create").post(async (req, res) => {
	const dbConnect = dbo.getDb();
	const { number, password } = req.query;
	if (number.length != 10) {
		res.status(400).send("Please enter a valid phone number");
	}
	dbConnect
		.collection("users")
		.insertOne({
			_id: ObjectID(),
			password: password,
			number: number,
			incomingRQ: true,
			notifications: false,
		})
		.then((response) => {
			res.status(200).send("sucessfully created user :P");
		});
});

// This section will help you delete a record.
// recordRoutes.route("/listings/delete/:id").delete((req, res) => {
// 	const dbConnect = dbo.getDb();
// 	const listingQuery = { listing_id: req.body.id };

// 	dbConnect
// 		.collection("listingsAndReviews")
// 		.deleteOne(listingQuery, function (err, _result) {
// 			if (err) {
// 				res.status(400).send(
// 					`Error deleting listing with id ${listingQuery.listing_id}!`,
// 				);
// 			} else {
// 				console.log("1 document deleted");
// 			}
// 		});
// });

module.exports = userRoutes;
