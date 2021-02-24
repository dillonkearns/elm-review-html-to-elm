module HtmlToTailwind exposing (htmlToElmTailwindModules)

import Dict
import Dict.Extra
import Html.Parser
import Regex


htmlToElmTailwindModules : String -> String
htmlToElmTailwindModules input =
    case Html.Parser.run input of
        Err error ->
            "ERROR"

        Ok value ->
            nodesToElm value


nodesToElm : List Html.Parser.Node -> String
nodesToElm nodes =
    List.filterMap nodeToElm nodes |> String.join ", "


nodeToElm : Html.Parser.Node -> Maybe String
nodeToElm node =
    case node of
        Html.Parser.Text textBody ->
            let
                trimmed =
                    String.trim textBody
            in
            if String.isEmpty trimmed then
                Nothing

            else
                "text \"" ++ textBody ++ "\"" |> Just

        Html.Parser.Element elementName attributes children ->
            elementName
                ++ " ["
                ++ (List.map
                        (attributeToElm >> surroundWithSpaces)
                        attributes
                        |> String.join ", "
                   )
                ++ "] ["
                ++ (List.filterMap nodeToElm children |> String.join ", " |> surroundWithSpaces)
                ++ "]"
                |> Just

        Html.Parser.Comment string ->
            Nothing


attributeToElm : Html.Parser.Attribute -> String
attributeToElm ( name, value ) =
    if name == "class" then
        let
            dict : Dict.Dict String (List String)
            dict =
                value
                    |> String.split " "
                    |> List.map splitOutBreakpoints
                    |> Dict.Extra.groupBy (Tuple.first >> Maybe.withDefault "")
                    |> Dict.map (\k v -> List.map Tuple.second v)

            newThing =
                dict
                    |> Dict.toList
                    |> List.map
                        (\( breakpoint, twClasses ) ->
                            --""
                            if breakpoint == "" then
                                twClasses
                                    |> List.map toTwClass
                                    |> String.join ", "

                            else
                                "Bp."
                                    ++ breakpoint
                                    ++ " [ "
                                    ++ (twClasses
                                            |> List.map toTwClass
                                            |> String.join ", "
                                       )
                                    ++ " ]"
                        )
        in
        "css [ " ++ String.join ", " newThing ++ " ]"

    else
        "TODO"


toTwClass : String -> String
toTwClass twClass =
    "Tw." ++ twClassToElmName twClass


{-| Mimics the rules in <https://github.com/matheus23/elm-tailwind-modules/blob/cd5809505934ff72c9b54fd1e181f67b53af8186/src/helpers.ts#L24-L59>
-}
twClassToElmName twClass =
    twClass
        |> Regex.replace (Regex.fromString "^-([a-z])" |> Maybe.withDefault Regex.never)
            (\match ->
                "neg_" ++ (match.submatches |> List.head |> Maybe.andThen identity |> Maybe.withDefault "")
            )
        |> String.replace "/" "over"
        |> String.replace "-" "_"


splitOutBreakpoints : String -> ( Maybe String, String )
splitOutBreakpoints tailwindClassName =
    case String.split ":" tailwindClassName of
        [ breakpoint, tailwindClass ] ->
            ( Just breakpoint, tailwindClass )

        [ tailwindClass ] ->
            ( Nothing, tailwindClass )

        _ ->
            ( Nothing, "" )


surroundWithSpaces : String -> String
surroundWithSpaces string =
    if String.isEmpty string then
        string

    else
        " " ++ string ++ " "
