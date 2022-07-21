module App.Router where

import Prelude hiding ((/))

import App.Routes (Page(..), Route(..), parseRoute, printRoute)
import Data.Newtype (class Newtype)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Ref as Ref
import Effect.Unsafe (unsafePerformEffect)
import React.Basic.Hooks (JSX, UseContext, Hook)
import React.Basic.Hooks as React
import Web.Router as Router
import Web.Router.PushState as PushState

type Router =
  { route :: Route
  , navigate :: Page -> Effect Unit
  , redirect :: Page -> Effect Unit
  }

newtype UseRouter :: Type -> Type
newtype UseRouter hooks = UseRouter (UseContext Router hooks)

derive instance newtypeUseRouter :: Newtype (UseRouter hooks) _

useRouter :: Hook UseRouter Router
useRouter =
  React.coerceHook do
    React.useContext routerContext

routerContext :: React.ReactContext Router
routerContext = unsafePerformEffect (React.createContext { route: Page Home, navigate: mempty, redirect: mempty })

mkRouter :: Effect (Array JSX -> JSX)
mkRouter = do
  subscriberRef <- Ref.new mempty
  let
    onNavigation _ _ = Router.continue
    onEvent = case _ of
      Router.Routing _ _ -> pure unit
      Router.Resolved _ route -> join (Ref.read subscriberRef <@> route)
  driver <- PushState.mkInterface parseRoute printRoute
  router <- Router.mkInterface onNavigation onEvent driver
  React.component "Router" \children -> React.do
    currentRoute /\ setCurrentRoute <- React.useState' $ Page Home
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
