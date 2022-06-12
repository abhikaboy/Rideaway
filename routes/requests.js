const express = require("express");
// The router will be added as a middleware and will take control of requests starting with path /listings.
const requestsRoute = express.Router();

// This will help us connect to the database
const dbo = require("../db/conn");
const { ObjectID } = require("bson");
/**
 *
 * @param {id} id the id of the request
 * @returns specific request
 */
const getRequestsById = async (id) => {
	const dbConnect = dbo.getDb();
	return await dbConnect
		.collection("requests")
		.findOne({ _id: ObjectID(id) });
};
/**
 *
 * @param {id} id of the user
 * @returns an array of all incomming requests for a user
 */
const getIncommingRequests = async (id) => {
	const dbConnect = dbo.getDb();
	const aggregated = await dbConnect.collection("requests").aggregate([
		{
			$project: {
				isRequested: {
					$in: [ObjectID(id), "$requesting"],
				},
				isNotAccepted: {
					$not: "$accepted",
				},
				_id: "$_id",
			},
		},
	]);
	// console.log(aggregated.toArray());
	return await aggregated.toArray().then((result) => {
		let filtered = result.filter((request) => {
			return request.isRequested && request.isNotAccepted;
		});
		console.log(filtered);
		return filtered;
	});
	// console.log(aggregated.toArray());
	// return aggregated.toArray();
	// .filter((request) => request.isRequested && request.isNotAccepted);
};
/**
 *
 * @param {*} id of user
 * @returns User's active outgoing request
 */
const getOutgoingRequest = async (id) => {
	const dbConnect = dbo.getDb();
	const rq = await dbConnect
		.collection("requests")
		.findOne({ requestor: ObjectID(id) });
	console.log(rq);
	return rq;
};

/**
 *
 */
const getUserByNumber = async (number) => {
	const dbConnect = dbo.getDb();
	return await dbConnect.collection("users").findOne({ number: number });
};

const getNumberByRequestId = async (id) => {
	console.log(id);
	const dbConnect = dbo.getDb();
	const requestorId = await dbConnect
		.collection("requests")
		.findOne({ _id: ObjectID(id) });
	console.log(requestorId.requestor);
	return await dbConnect
		.collection("users")
		.findOne({ _id: ObjectID(requestorId.requestor.toString()) });
};
/**
 *
 * @param {Array} requsting Array of phone numbers to request to
 * @returns filtered arary of id's based on numbers to send to
 */
const filterRequesting = async (requesting) => {
	return Promise.all(
		requesting.map(async (number) => {
			const user = await getUserByNumber(number);
			if (user == null) return;
			if (!user.incomingRQ) return; // user is not accepting incomming requests
			return user._id;
		}),
	);
};

// Handling general request route, will fetch a request by id or list em
requestsRoute.route("/requests").get(async function (req, res) {
	const dbConnect = dbo.getDb();
	const { id } = req.query;
	if (typeof id != "undefined") {
		console.log("looking for a specific request");
		await getRequestsById(id).then((response) => {
			res.json(response);
		});
	} else {
		console.log("listing all requests");
		dbConnect
			.collection("requests")
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

// Creates a user request based off a user ID
requestsRoute.route("/requests/create").post(async (req, res) => {
	const dbConnect = dbo.getDb();
	const { id, requesting, destination, arrivalTime, comment } = req.query;
	if (typeof id == "undefined") {
		res.status(400).send("No user given");
	}
	// 04:04 AM
	let requestingUsers = await filterRequesting(requesting);
	requestingUsers = requestingUsers.filter((element) => element != null);
	dbConnect
		.collection("requests")
		.insertOne({
			_id: ObjectID(),
			requestor: ObjectID(id),
			destination: destination,
			comment: comment,
			requesting: requestingUsers,
			createdAt: new Date(),
			accepted: false,
			acceptor: "",
			arrivalTime: new Date(),
		})
		.then((response) => {
			res.status(200).send("yuh");
		});
});
requestsRoute.route("/requests/incomming").get(async (req, res) => {
	const dbConnect = dbo.getDb();
	const { id } = req.query;
	await getIncommingRequests(id).then(async (response) => {
		res.status(200).send(response);
	});
});
requestsRoute.route("/requests/outgoing").get(async (req, res) => {
	const dbConnect = dbo.getDb();
	const { id } = req.query;
	await getOutgoingRequest(id).then(async (response) => {
		res.status(200).send(response);
	});
});
requestsRoute.route("/requests/number").get(async (req, res) => {
	const dbConnect = dbo.getDb();
	const { id } = req.query;
	await getNumberByRequestId(id).then(async (response) => {
		res.status(200).send(response.number);
	});
});
requestsRoute.route("/requests/accept").post(async (req, res) => {
	const dbConnect = dbo.getDb();
	const { requestID, acceptor } = req.query;
	await dbConnect
		.collection("requests")
		.updateOne(
			{ _id: ObjectID(requestID) },
			{
				$set: { accepted: true, acceptor: ObjectID(acceptor) },
			},
		)
		.then((response) => {
			// console.log(response);
			res.send(`Request ${requestID} has been accepted by ${acceptor}`);
		});
});
module.exports = requestsRoute;
