module App where

import Prelude hiding ((/))

import App.Router as AppRouter
import App.Routes (Page(..), Route(..))
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
                  Page page -> case page of
                    Home -> "Home"
                    ProductList -> "Products"
                    ProductView productId -> "Product " <> show productId
                    About -> "About"
                    ContactUs -> "Contact Us"
                  NotFound -> "Not Found"
              ]
          , R.div_
              [ R.text "Menu: "
              , R.ul_
                  [ R.button
                      { onClick: handler_ $ router.navigate Home
                      , children: [ R.text "Go to Home page" ]
                      }
                  , R.button
                      { onClick: handler_ $ router.navigate ProductList
                      , children: [ R.text "Go to Products listing" ]
                      }
                  , R.button
                      { onClick: handler_ $ router.navigate About
                      , children: [ R.text "Go to About page" ]
                      }
                  , R.button
                      { onClick: handler_ $ router.navigate ContactUs
                      , children: [ R.text "Go to Contact Us page" ]
                      }
                  ]
              ]
          ]
