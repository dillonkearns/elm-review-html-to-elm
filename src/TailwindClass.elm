module TailwindClass exposing (classAttributeToElm)

import ConfigHelpers as Config
import Context exposing (Context(..))
import Dict exposing (Dict)
import Dict.Extra
import FormattedElm exposing (indentedThingy)
import HtmlToElm.Config exposing (Config)
import ImplementedFunctions
import Regex


classAttributeToElm : Config -> Context -> Int -> String -> String
classAttributeToElm config context indentLevel value =
    let
        dict : Dict String (Dict String (List String))
        dict =
            value
                |> String.split " "
                |> List.map String.trim
                |> List.filter (\item -> not (String.isEmpty item))
                |> List.map splitOutBreakpoints
                |> Dict.Extra.groupBy .breakpoint
                |> Dict.map
                    (\_ v ->
                        v
                            |> Dict.Extra.groupBy .pseudoClass
                            |> Dict.map
                                (\_ v2 ->
                                    List.map .tailwindClass v2
                                )
                    )

        newThing : List String
        newThing =
            dict
                |> Dict.toList
                |> List.map
                    (\( breakpoint, twClasses ) ->
                        if breakpoint == "" then
                            let
                                allClasses : List String
                                allClasses =
                                    twClasses
                                        |> Dict.values
                                        |> List.concat
                            in
                            allClasses
                                |> List.map (toTwClass config)

                        else
                            twClasses
                                |> Dict.toList
                                |> List.map
                                    (\( pseudoclass, twClassList ) ->
                                        if pseudoclass == "" then
                                            twClassList
                                                |> List.map (toTwClass config)

                                        else
                                            case ImplementedFunctions.lookupWithDict ImplementedFunctions.pseudoClasses ImplementedFunctions.cssHelpers pseudoclass of
                                                Just functionName ->
                                                    [ "Css."
                                                        ++ functionName
                                                        ++ " "
                                                        ++ indentedThingy (indentLevel + 3) (toTwClass config) twClassList
                                                    ]

                                                Nothing ->
                                                    [ Config.bp config breakpoint
                                                        ++ indentedThingy (indentLevel + 3) (toTwClass config) twClassList
                                                    ]
                                    )
                                |> List.concat
                                --|> List.map (\thing -> indentedThingy (indentLevel + 2) identity thing)
                                |> (\thing ->
                                        [ breakpointName config breakpoint
                                            ++ indentedThingy (indentLevel + 2) identity thing
                                        ]
                                   )
                    )
                |> List.concat

        cssFunction : String
        cssFunction =
            case context of
                Html ->
                    Config.htmlAttr config "css"

                Svg ->
                    Config.svgAttr config "css"
    in
    cssFunction ++ indentedThingy (indentLevel + 1) identity newThing


toTwClass : Config -> String -> String
toTwClass config twClass =
    Config.tw config (twClassToElmName config twClass)


{-| Mimics the rules in <https://github.com/matheus23/elm-tailwind-modules/blob/cd5809505934ff72c9b54fd1e181f67b53af8186/src/helpers.ts#L24-L59>
-}
twClassToElmName : Config -> String -> String
twClassToElmName config twClass =
    twClass
        |> Regex.replace (Regex.fromString "^-([a-z])" |> Maybe.withDefault Regex.never)
            (\match ->
                "neg_" ++ (match.submatches |> List.head |> Maybe.andThen identity |> Maybe.withDefault "")
            )
        |> Regex.replace (Regex.fromString "\\." |> Maybe.withDefault Regex.never)
            (\_ ->
                "_dot_"
            )
        |> replaceColorNamesWithFunctions config
        |> String.replace "/" "over"
        |> String.replace "-" "_"


{-| Examples: replaces bg-red-100 with Tw.bg\_color Tw.red-100 and bg-transparent with Tw.bg\_color Tw.transparent
-}
replaceColorNamesWithFunctions : Config -> String -> String
replaceColorNamesWithFunctions config input =
    Regex.replace
        (Regex.fromString "(\\w+)\\W(\\w+\\W\\d{2,3}|black|current|inherit|transparent|white)" |> Maybe.withDefault Regex.never)
        (\match ->
            (match.submatches
                |> List.head
                |> Maybe.andThen identity
                |> Maybe.withDefault ""
            )
                ++ "_color "
                ++ Config.tw config ""
                ++ (match.submatches
                        |> List.drop 1
                        |> List.head
                        |> Maybe.andThen identity
                        |> Maybe.withDefault ""
                   )
        )
        input


breakpointName : Config -> String -> String
breakpointName config breakpoint =
    case ImplementedFunctions.lookupWithDict ImplementedFunctions.pseudoClasses ImplementedFunctions.cssHelpers breakpoint of
        Just functionName ->
            "Css." ++ functionName

        Nothing ->
            Config.bp config breakpoint


splitOutBreakpoints : String -> { breakpoint : String, pseudoClass : String, tailwindClass : String }
splitOutBreakpoints tailwindClassName =
    case String.split ":" tailwindClassName of
        [ breakpoint, pseudoClass, tailwindClass ] ->
            { breakpoint = breakpoint
            , pseudoClass = pseudoClass
            , tailwindClass = tailwindClass
            }

        [ breakpoint, tailwindClass ] ->
            { breakpoint = breakpoint
            , pseudoClass = ""
            , tailwindClass = tailwindClass
            }

        [ tailwindClass ] ->
            { breakpoint = ""
            , pseudoClass = ""
            , tailwindClass = tailwindClass
            }

        _ ->
            { breakpoint = ""
            , pseudoClass = ""
            , tailwindClass = ""
            }
