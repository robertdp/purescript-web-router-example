module Main where

import Prelude
import App as App
import App.Router as AppRouter
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception as Exception
import React.Basic.DOM as ReactDOM
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  container <- getElementById "app" =<< (map toNonElementParentNode $ document =<< window)
  case container of
    Nothing -> Exception.throw "App container element not found."
    Just c -> do
      router <- AppRouter.mkRouter
      app <- App.makeApp
      ReactDOM.render (router [ app unit ]) c
