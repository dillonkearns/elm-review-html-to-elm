module HtmlToElm.Config exposing
    ( Config, Exposing(..)
    , default
    )

{-|

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
