module HtmlToElm.Config exposing
    ( Config, Exposing(..)
    , default
    )

{-| If you're running this through the `elm-review` Rule, you won't need this Config. It infers the config from
the context of the file it applies the fix to for the `elm-review` Rule. If you are running the more low-level helper
[`HtmlToElm.htmlToElm`](HtmlToElm.htmlToElm) directly then you will need to pass it a config.

@docs Config, Exposing

@docs default

-}


{-| -}
type alias Config =
    { html : ( String, Exposing )
    , htmlAttr : ( String, Exposing )
    , svg : ( String, Exposing )
    , svgAttr : ( String, Exposing )
    , tw : ( String, Exposing )
    , bp : ( String, Exposing )
    , useTailwindModules : Bool
    }


{-| -}
type Exposing
    = All
    | None
    | Some (List String)


{-| -}
default : Config
default =
    { html = ( "Html", All )
    , htmlAttr = ( "Attr", Some [ "css" ] )
    , svg = ( "Svg", Some [ "svg", "path" ] )
    , svgAttr = ( "SvgAttr", None )
    , tw = ( "Tw", None )
    , bp = ( "Bp", None )
    , useTailwindModules = False
    }
