module Config exposing
    ( Config
    , Exposing(..)
    , bp
    , default
    , getExposingString
    , htmlAttr
    , htmlTag
    , svgAttr
    , svgTag
    , testConfig
    , toggleUseTailwindClasses
    , tw
    , updateBpAlias
    , updateBpExposing
    , updateHtmlAlias
    , updateHtmlAttrAlias
    , updateHtmlAttrExposing
    , updateHtmlExposing
    , updateSvgAlias
    , updateSvgAttrAlias
    , updateSvgAttrExposing
    , updateSvgExposing
    , updateTwAlias
    , updateTwExposing
    )


type alias Config =
    { html : ( String, Exposing )
    , htmlAttr : ( String, Exposing )
    , svg : ( String, Exposing )
    , svgAttr : ( String, Exposing )
    , tw : ( String, Exposing )
    , bp : ( String, Exposing )
    , useTailwindModules : Bool
    }


getExposingString : ( String, Exposing ) -> String
getExposingString ( importAlias, importExposing ) =
    exposingToString importExposing


exposingToString : Exposing -> String
exposingToString importExposing =
    case importExposing of
        None ->
            ""

        Some list ->
            list
                |> String.join ", "

        All ->
            ".."


updateHtmlAlias : Config -> String -> Config
updateHtmlAlias config newAlias =
    { config | html = config.html |> updateAlias "Html" newAlias }


updateSvgAlias : Config -> String -> Config
updateSvgAlias config newAlias =
    { config | svg = config.svg |> updateAlias "Svg" newAlias }


updateHtmlAttrAlias : Config -> String -> Config
updateHtmlAttrAlias config newAlias =
    { config | htmlAttr = config.htmlAttr |> updateAlias "Attr" newAlias }


updateSvgAttrAlias : Config -> String -> Config
updateSvgAttrAlias config newAlias =
    { config | svgAttr = config.svgAttr |> updateAlias "SvgAttr" newAlias }


updateTwAlias : Config -> String -> Config
updateTwAlias config newAlias =
    { config | tw = config.tw |> updateAlias "Tw" newAlias }


updateBpAlias : Config -> String -> Config
updateBpAlias config newAlias =
    { config | bp = config.bp |> updateAlias "Bp" newAlias }


updateHtmlExposing : Config -> String -> Config
updateHtmlExposing config newExposing =
    { config | html = config.html |> updateExposing All newExposing }


updateSvgExposing : Config -> String -> Config
updateSvgExposing config newExposing =
    { config | svg = config.svg |> updateExposing (Some [ "path", "svg" ]) newExposing }


updateHtmlAttrExposing : Config -> String -> Config
updateHtmlAttrExposing config newExposing =
    { config | htmlAttr = config.htmlAttr |> updateExposing None newExposing }


updateSvgAttrExposing : Config -> String -> Config
updateSvgAttrExposing config newExposing =
    { config | svgAttr = config.svgAttr |> updateExposing None newExposing }


updateTwExposing : Config -> String -> Config
updateTwExposing config newExposing =
    { config | tw = config.tw |> updateExposing None newExposing }


updateBpExposing : Config -> String -> Config
updateBpExposing config newExposing =
    { config | bp = config.bp |> updateExposing None newExposing }


updateAlias : String -> String -> ( String, Exposing ) -> ( String, Exposing )
updateAlias defaultAlias newAlias ( importAlias, importExposing ) =
    ( if newAlias == "" then
        defaultAlias

      else
        newAlias
    , importExposing
    )


updateExposing : Exposing -> String -> ( String, Exposing ) -> ( String, Exposing )
updateExposing defaultExposing newExposing ( importAlias, importExposing ) =
    ( importAlias
    , parseExposing newExposing
    )


parseExposing : String -> Exposing
parseExposing exposingString =
    if exposingString == ".." then
        All

    else if exposingString == "" then
        None

    else
        exposingString
            |> String.split ","
            |> List.map String.trim
            |> Some


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


testConfig : Config
testConfig =
    { html = ( "Html", All )
    , htmlAttr = ( "Attr", Some [ "attribute", "css" ] )
    , svg = ( "Svg", None )
    , svgAttr = ( "SvgAttr", None )
    , tw = ( "Tw", None )
    , bp = ( "Bp", None )
    , useTailwindModules = True
    }


toggleUseTailwindClasses : Config -> Config
toggleUseTailwindClasses config =
    { config | useTailwindModules = not config.useTailwindModules }


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
