module App.Routes
  ( Page(..)
  , ProductId
  , Route(..)
  , parseRoute
  , printRoute
  , productId
  ) where

import Prelude hiding ((/))

import Data.Either (Either)
import Data.Generic.Rep (class Generic)
import Routing.Duplex (RouteDuplex', default, end, int, parse, print, root, segment)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))
import Routing.Duplex.Parser (RouteError)

data Route
  = Page Page
  | NotFound

data Page
  = Home
  | ProductList
  | ProductView ProductId
  | About
  | ContactUs

derive instance Generic Route _

derive instance Generic Page _

type ProductId = Int

productId :: RouteDuplex' Int
productId = int segment

routes :: RouteDuplex' Route
routes =
  default NotFound $
    sum
      { "Page": pages
      , "NotFound": "404" / noArgs
      }

pages :: RouteDuplex' Page
pages =
  root $ end $ sum
    { "Home": noArgs
    , "ProductList": "products" / noArgs
    , "ProductView": "products" / productId
    , "About": "about" / noArgs
    , "ContactUs": "contact-us" / noArgs
    }

parseRoute :: String -> Either RouteError Route
parseRoute = parse routes

printRoute :: Page -> String
printRoute = print pages
