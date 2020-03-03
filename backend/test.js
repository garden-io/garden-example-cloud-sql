const supertest = require("supertest")
const { app } = require("./app")

describe('GET /hello', () => {
  const agent = supertest.agent(app)

  it('should respond with the username', (done) => {
    agent
      .get("/hello")
      .expect(200, /Hello .*/)
      .end((err) => {
        if (err) return done(err)
        done()
      })
  })
})
