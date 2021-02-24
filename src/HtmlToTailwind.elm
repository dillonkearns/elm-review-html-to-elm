module HtmlToTailwind exposing (htmlToElmTailwindModules)

import Dict
import Dict.Extra
import Html.Parser


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
            if String.isEmpty textBody then
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


toTwClass twClass =
    "Tw." ++ String.replace "-" "_" twClass


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
