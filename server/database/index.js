import sqlite from "sqlite3";

sqlite = sqlite.verbose();

/**
 * @param {Error} err
 * @returns void
 */
const connection = (err) =>
	err ? console.error(err) : console.log("Database connected!");

let dbConnection = null;

class Database {
	constructor() {
		return dbConnection
			? dbConnection
			: (dbConnection = new sqlite.Database(
					process.env.DB_NAME,
					connection
			  ));
	}
}

export default Database;
