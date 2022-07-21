{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies =
  [ "effect"
  , "either"
  , "exceptions"
  , "maybe"
  , "newtype"
  , "prelude"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "refs"
  , "routing-duplex"
  , "tuples"
  , "web-dom"
  , "web-html"
  , "web-router"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
