module App where

import Prelude hiding ((/))
import App.Router as AppRouter
import App.Routes (Route(..))
import Effect (Effect)
import React.Basic.DOM as R
import React.Basic.Events (handler_)
import React.Basic.Hooks (JSX)
import React.Basic.Hooks as React

mkApp :: Effect (Unit -> JSX)
mkApp = do
  React.component "App" \_ -> React.do
    router <- AppRouter.useRouter
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
