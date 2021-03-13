module Example.RoutingDuplex where

import Prelude hiding ((/))
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Exception as Exception
import Effect.Ref as Ref
import Effect.Unsafe (unsafePerformEffect)
import React.Basic.DOM as R
import React.Basic.DOM as ReactDOM
import React.Basic.Events (handler_)
import React.Basic.Hooks (JSX)
import React.Basic.Hooks as React
import Routing.Duplex (RouteDuplex', default, end, parse, print, root)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)
import Web.Router as Router
import Web.Router.Driver.PushState as PushState
import Web.Router.Types (Event(..))

data Route
  = Home
  | About
  | NotFound

derive instance genericRoute :: Generic Route _

routes :: RouteDuplex' Route
routes =
  default NotFound
    $ root
    $ sum
        { "Home": end noArgs
        , "About": "about" / end noArgs
        , "NotFound": "404" / end noArgs
        }

main :: Effect Unit
main = do
  container <- getElementById "app" =<< (map toNonElementParentNode $ document =<< window)
  case container of
    Nothing -> Exception.throw "App container element not found."
    Just c -> do
      router <- makeRouter
      app <- makeApp
      ReactDOM.render (router [ app unit ]) c

routerContext :: React.ReactContext { route :: Route, navigate :: Route -> Effect Unit, redirect :: Route -> Effect Unit }
routerContext = unsafePerformEffect (React.createContext { route: Home, navigate: mempty, redirect: mempty })

makeRouter :: Effect (Array JSX -> JSX)
makeRouter = do
  subscriberRef <- Ref.new \_ -> pure unit
  router <-
    PushState.makeRouter
      (parse routes)
      (print routes)
      (\_ _ -> Router.continue)
      ( case _ of
          Transitioning _ _ -> pure unit
          Resolved _ route -> join (Ref.read subscriberRef <@> route)
      )
  React.component "Router" \children -> React.do
    currentRoute /\ setCurrentRoute <- React.useState' Home
    React.useEffectOnce do
      Ref.write setCurrentRoute subscriberRef
      router.initialize
    pure
      $ React.provider routerContext
          { route: currentRoute
          , navigate: router.navigate
          , redirect: router.redirect
          }
          children

makeApp :: Effect (Unit -> JSX)
makeApp = do
  React.component "App" \_ -> React.do
    router <- React.useContext routerContext
    pure
      $ React.fragment
          [ R.h1_
              [ R.text case router.route of
                  Home -> "Home"
                  About -> "About"
                  NotFound -> "Not Found"
              ]
          , R.div_
              [ R.text "Menu: "
              , R.button
                  { onClick: handler_ $ router.navigate Home
                  , children: [ R.text "Go to Home page" ]
                  }
              , R.button
                  { onClick: handler_ $ router.navigate About
                  , children: [ R.text "Go to About page" ]
                  }
              ]
          ]
