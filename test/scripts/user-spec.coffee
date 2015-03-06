'use strict'

request = require 'request'
querystring = require 'querystring'
chai = require 'chai'

chai.should()

ROUTE = 'http://localhost:3000/users/'

##
# Query empty db
# 
describe 'GET /users/', ->
  it 'should return 200', (done) ->
    request.get ROUTE, (err, res) ->
      res.statusCode.should.equal 200
      done()

  it 'should return empty result', (done) ->
    request.get ROUTE, (err, res, body) ->
        obj = JSON.parse body
        obj.should.have.property 'users'
        obj.users.length.should.equal 0
        done()

##
# Create user
# 
describe 'POST /users/', ->

  it 'should return 200', (done) ->
    user = {
      form: {
        username: 'John Doe'
        password: 'secret'
      }
    }

    request.post ROUTE, user, (err, res) ->
      res.statusCode.should.equal 200
      done()

  it 'should create a new user', (done) ->
    request.get ROUTE, (err, res, body) ->
        obj = JSON.parse body
        obj.should.have.property 'users'
        obj.users.length.should.equal 1
        obj.users[0].should.have.property 'username'
        obj.users[0].should.have.property 'password'
        obj.users[0].username.should.equal 'John Doe'
        obj.users[0].password.should.equal 'secret'

        done()
