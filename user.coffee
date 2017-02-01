x = ->
  true

self =
  isExisting:
    x()
    # true # replace w ls check

  isSignedIn:
    true # replace w ls check



module.exports = self
