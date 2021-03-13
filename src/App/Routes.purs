module App.Routes where

import Prelude hiding ((/))
import Data.Either (Either)
import Data.Generic.Rep (class Generic)
import Routing.Duplex (RouteDuplex')
import Routing.Duplex as RD
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))
import Routing.Duplex.Parser (RouteError)

data Route
  = Home
  | About
  | NotFound

derive instance genericRoute :: Generic Route _

routes :: RouteDuplex' Route
routes =
  RD.default NotFound
    $ RD.root
    $ sum
        { "Home": noArgs
        , "About": "about" / noArgs
        , "NotFound": "404" / noArgs
        }

parseRoute :: String -> Either RouteError Route
parseRoute = RD.parse routes

printRoute :: Route -> String
printRoute = RD.print routes
