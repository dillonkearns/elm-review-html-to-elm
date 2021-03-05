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
            List.filterMap (nodeToElm 1 Html) value |> join


type Separator
    = CommaSeparator
    | NoSeparator


join : List ( Separator, String ) -> String
join nodes =
    case nodes of
        [] ->
            ""

        [ ( separator, singleNode ) ] ->
            singleNode

        ( separator1, node1 ) :: otherNodes ->
            case separator1 of
                NoSeparator ->
                    node1 ++ "" ++ join otherNodes

                CommaSeparator ->
                    node1 ++ ", " ++ join otherNodes


nodeToElm : Int -> Context -> Html.Parser.Node -> Maybe ( Separator, String )
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
                ( CommaSeparator, "text \"" ++ trimmed ++ "\"" ) |> Just

        Html.Parser.Element elementName attributes children ->
            let
                elementFunction =
                    case newContext of
                        Svg ->
                            "Svg."
                                ++ (case ImplementedFunctions.lookup ImplementedFunctions.svgTags elementName of
                                        Just functionName ->
                                            functionName

                                        Nothing ->
                                            "node \"" ++ elementName ++ "\""
                                   )

                        Html ->
                            ""
                                ++ (case ImplementedFunctions.lookup ImplementedFunctions.htmlTags elementName of
                                        Just functionName ->
                                            functionName

                                        Nothing ->
                                            "node \"" ++ elementName ++ "\""
                                   )

                isSvg =
                    isSvgContext attributes

                newContext =
                    if isSvg then
                        Svg

                    else
                        context

                filteredAttributes =
                    List.filterMap
                        (\attribute ->
                            attribute
                                |> attributeToElm (indentLevel + 1)
                                    newContext
                        )
                        attributes
            in
            ( CommaSeparator
            , (if indentLevel == 1 then
                "    "

               else
                ""
              )
                ++ elementFunction
                ++ (indentedThingy (indentLevel + 1) identity filteredAttributes
                        ++ indentation indentLevel
                        ++ "      ["
                        ++ (List.filterMap (nodeToElm (indentLevel + 1) newContext) children |> join |> surroundWithSpaces)
                        ++ "]\n"
                        ++ indentation indentLevel
                   )
            )
                |> Just

        Html.Parser.Comment string ->
            Just <| ( NoSeparator, indentation indentLevel ++ "{-" ++ string ++ "-}\n" ++ indentation indentLevel )


indentedThingy : Int -> (a -> String) -> List a -> String
indentedThingy indentLevel function list =
    if List.isEmpty list then
        " []\n"

    else
        (list
            |> List.indexedMap
                (\index element ->
                    if index == 0 then
                        "\n" ++ indentation indentLevel ++ "[ " ++ function element

                    else
                        "\n" ++ indentation indentLevel ++ ", " ++ function element
                )
            |> String.join ""
        )
            ++ "\n"
            ++ indentation indentLevel
            ++ "]\n"


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


attributeToElm : Int -> Context -> Html.Parser.Attribute -> Maybe String
attributeToElm indentLevel context ( name, value ) =
    if name == "xmlns" then
        Nothing

    else if name == "class" then
        Just <|
            classAttributeToElm indentLevel value

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
            Just <| "SvgAttr." ++ ImplementedFunctions.toCamelCase functionName ++ " \"" ++ value ++ "\""

        Nothing ->
            Just <| "attribute \"" ++ name ++ "\" \"" ++ value ++ "\""


classAttributeToElm : Int -> String -> String
classAttributeToElm indentLevel value =
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
                        if breakpoint == "" then
                            twClasses
                                |> List.map toTwClass
                            ----    |> String.join ", "
                            --indentedThingy (indentLevel + 1) toTwClass twClasses

                        else
                            case ImplementedFunctions.lookup ImplementedFunctions.cssHelpers breakpoint of
                                Just functionName ->
                                    [ "Css."
                                        ++ functionName
                                        ++ " "
                                        ++ indentedThingy (indentLevel + 1) toTwClass twClasses
                                    ]

                                Nothing ->
                                    [ "Bp."
                                        ++ breakpoint
                                        ++ indentedThingy (indentLevel + 1) toTwClass twClasses
                                    ]
                    )
                |> List.concat
    in
    --"css [ " ++ String.join ", " newThing ++ " ]"
    "css" ++ indentedThingy (indentLevel + 1) identity newThing


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
