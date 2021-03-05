module HtmlToTailwind exposing (htmlToElmTailwindModules)

import Dict exposing (Dict)
import Dict.Extra
import Html.Parser
import ImplementedFunctions
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
    List.filterMap (nodeToElm 1 Html) nodes |> join


type Separator
    = CommaSeparator
    | NoSeparator


join : List ( Int, Separator, String ) -> String
join nodes =
    case nodes of
        [] ->
            ""

        [ ( indentLevel, separator, singleNode ) ] ->
            singleNode

        ( indentLevel1, separator1, node1 ) :: (( indentLevel2, separator2, node2 ) as part2) :: otherNodes ->
            case separator1 of
                NoSeparator ->
                    node1 ++ "" ++ join (part2 :: otherNodes)

                CommaSeparator ->
                    node1 ++ ", " ++ join (part2 :: otherNodes)


nodeToElm : Int -> Context -> Html.Parser.Node -> Maybe ( Int, Separator, String )
nodeToElm indentLevel context node =
    case node of
        Html.Parser.Text textBody ->
            let
                trimmed =
                    String.trim textBody
                        |> Regex.replace
                            (Regex.fromString "\\s+"
                                |> Maybe.withDefault Regex.never
                            )
                            (\_ -> " ")
            in
            if String.isEmpty trimmed then
                Nothing

            else
                ( 0, CommaSeparator, "text \"" ++ trimmed ++ "\"" ) |> Just

        Html.Parser.Element elementName attributes children ->
            let
                isSvg =
                    isSvgContext attributes
            in
            ( indentLevel
            , CommaSeparator
            , (if indentLevel == 1 then
                "    "

               else
                ""
              )
                ++ elementName
                ++ " ["
                ++ (List.filterMap
                        (\attribute ->
                            attribute
                                |> attributeToElm
                                    (if isSvg then
                                        Svg

                                     else
                                        context
                                    )
                                |> Maybe.map surroundWithSpaces
                        )
                        attributes
                        |> String.join ", "
                   )
                ++ "]\n"
                ++ indentation indentLevel
                ++ "      ["
                ++ (List.filterMap (nodeToElm (indentLevel + 1) context) children |> join |> surroundWithSpaces)
                ++ "]\n"
                ++ indentation indentLevel
            )
                |> Just

        Html.Parser.Comment string ->
            Just <| ( indentLevel, NoSeparator, indentation indentLevel ++ "{-" ++ string ++ "-}\n" )


indentation : Int -> String
indentation level =
    String.repeat (level * 4) " "


isSvgContext : List ( String, String ) -> Bool
isSvgContext attributes =
    attributes
        |> List.any (\( key, value ) -> key == "xmlns")


type Context
    = Html
    | Svg


attributeToElm : Context -> Html.Parser.Attribute -> Maybe String
attributeToElm context ( name, value ) =
    if name == "xmlns" then
        Nothing

    else if name == "class" then
        Just <|
            classAttributeToElm value

    else if context == Svg then
        svgAttr ( name, value )

    else
        case ImplementedFunctions.lookup ImplementedFunctions.htmlAttributes name of
            Just functionName ->
                Just <| "Attr." ++ functionName ++ " \"" ++ value ++ "\""

            Nothing ->
                Just <| "attribute \"" ++ name ++ "\" \"" ++ value ++ "\""


svgAttr : ( String, String ) -> Maybe String
svgAttr ( name, value ) =
    case ImplementedFunctions.lookup ImplementedFunctions.svgAttributes name of
        Just functionName ->
            Just <| "SvgAttr." ++ functionName ++ " \"" ++ value ++ "\""

        Nothing ->
            Just <| "attribute \"" ++ name ++ "\" \"" ++ value ++ "\""


classAttributeToElm : String -> String
classAttributeToElm value =
    let
        dict : Dict String (List String)
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
                            case ImplementedFunctions.lookup ImplementedFunctions.cssHelpers breakpoint of
                                Just functionName ->
                                    "Css."
                                        ++ functionName
                                        ++ " [ "
                                        ++ (twClasses
                                                |> List.map toTwClass
                                                |> String.join ", "
                                           )
                                        ++ " ]"

                                Nothing ->
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
        |> Regex.replace (Regex.fromString "\\." |> Maybe.withDefault Regex.never)
            (\match ->
                "_dot_"
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
