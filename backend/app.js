const express = require("express")
const knex = require("knex")({
  client: "postgresql",
  connection: {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    database: "postgres",
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
  },
})

const app = express();

app.get('/', (_req, res) => res.send('Ok'));

app.get("/hello", (req, res) => {
  knex.select("name").from("users")
    .then((rows) => {
      res.send(`Hello ${rows.map(r => r.name).join(', ')}`)
    })
});

module.exports = { app }