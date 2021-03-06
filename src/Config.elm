module Config exposing (..)


type alias Config =
    { html : ( String, Exposing )
    , htmlAttr : ( String, Exposing )
    , svg : ( String, Exposing )
    , svgAttr : ( String, Exposing )
    , tw : ( String, Exposing )
    , bp : ( String, Exposing )
    }


updateHtmlAlias config newAlias =
    { config | html = config.html |> updateAlias "Html" newAlias }


updateSvgAlias config newAlias =
    { config | svg = config.svg |> updateAlias "Svg" newAlias }


updateHtmlAttrAlias config newAlias =
    { config | htmlAttr = config.htmlAttr |> updateAlias "Attr" newAlias }


updateSvgAttrAlias config newAlias =
    { config | svgAttr = config.svgAttr |> updateAlias "SvgAttr" newAlias }


updateTwAlias config newAlias =
    { config | tw = config.tw |> updateAlias "Tw" newAlias }


updateBpAlias config newAlias =
    { config | bp = config.bp |> updateAlias "Bp" newAlias }


updateAlias : String -> String -> ( String, Exposing ) -> ( String, Exposing )
updateAlias defaultAlias newAlias ( importAlias, importExposing ) =
    ( if newAlias == "" then
        defaultAlias

      else
        newAlias
    , importExposing
    )


default : Config
default =
    { html = ( "Html", None )
    , htmlAttr = ( "Attr", None )
    , svg = ( "Svg", None )
    , svgAttr = ( "SvgAttr", None )
    , tw = ( "Tw", None )
    , bp = ( "Bp", None )
    }


testConfig : Config
testConfig =
    { html = ( "Html", All )
    , htmlAttr = ( "Attr", Some [ "attribute", "css" ] )
    , svg = ( "Svg", None )
    , svgAttr = ( "SvgAttr", None )
    , tw = ( "Tw", None )
    , bp = ( "Bp", None )
    }


type Exposing
    = All
    | None
    | Some (List String)


getter : (Config -> ( String, Exposing )) -> Config -> String -> String
getter getFn config tagName =
    if isExposed tagName (config |> getFn |> Tuple.second) then
        tagName

    else
        Tuple.first (config |> getFn) ++ "." ++ tagName


htmlTag : Config -> String -> String
htmlTag =
    getter .html


htmlAttr : Config -> String -> String
htmlAttr =
    getter .htmlAttr


svgTag : Config -> String -> String
svgTag =
    getter .svg


svgAttr : Config -> String -> String
svgAttr =
    getter .svgAttr


bp : Config -> String -> String
bp =
    getter .bp


tw : Config -> String -> String
tw =
    getter .tw


isExposed : String -> Exposing -> Bool
isExposed tagName exposing_ =
    case exposing_ of
        All ->
            True

        None ->
            False

        Some exposedValues ->
            List.member tagName exposedValues
