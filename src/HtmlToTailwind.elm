module HtmlToTailwind exposing (htmlToElmTailwindModules)

import ConfigHelpers as Config
import Context exposing (Context(..))
import FormattedElm exposing (indentation, indentedThingy)
import Html.Parser
import HtmlToElm.Config exposing (Config)
import ImplementedFunctions
import Regex
import TailwindClass


htmlToElmTailwindModules : Config -> String -> String
htmlToElmTailwindModules config input =
    case Html.Parser.run input of
        Err _ ->
            "ERROR"

        Ok value ->
            List.filterMap (nodeToElm config 1 Html) value |> join


type Separator
    = CommaSeparator
    | NoSeparator


join : List ( Separator, String ) -> String
join nodes =
    case nodes of
        [] ->
            ""

        [ ( _, singleNode ) ] ->
            singleNode

        ( separator1, node1 ) :: otherNodes ->
            case separator1 of
                NoSeparator ->
                    node1 ++ "" ++ join otherNodes

                CommaSeparator ->
                    node1 ++ ", " ++ join otherNodes


nodeToElm : Config -> Int -> Context -> Html.Parser.Node -> Maybe ( Separator, String )
nodeToElm config indentLevel context node =
    case node of
        Html.Parser.Text textBody ->
            let
                trimmed : String
                trimmed =
                    textBody
                        |> Regex.replace
                            (Regex.fromStringWith
                                { caseInsensitive = True
                                , multiline = True
                                }
                                "\\s+"
                                |> Maybe.withDefault Regex.never
                            )
                            (\_ -> " ")
                        |> Regex.replace
                            (Regex.fromStringWith
                                { caseInsensitive = True
                                , multiline = True
                                }
                                "^\\s*$"
                                |> Maybe.withDefault Regex.never
                            )
                            (\_ -> "")
                        |> String.replace "\"" "\\\""
            in
            if String.isEmpty trimmed then
                Nothing

            else
                ( CommaSeparator, Config.htmlTag config "text" ++ " \"" ++ trimmed ++ "\"" ) |> Just

        Html.Parser.Element elementName attributes children ->
            let
                elementFunction : String
                elementFunction =
                    case newContext of
                        Svg ->
                            case ImplementedFunctions.lookup ImplementedFunctions.svgTags elementName of
                                Just functionName ->
                                    Config.svgTag config functionName

                                Nothing ->
                                    Config.svgTag config "node" ++ " \"" ++ elementName ++ "\""

                        Html ->
                            case ImplementedFunctions.lookupWithDict ImplementedFunctions.htmlTagsDict ImplementedFunctions.htmlTags elementName of
                                Just functionName ->
                                    Config.htmlTag config functionName

                                Nothing ->
                                    Config.htmlTag config "node" ++ " \"" ++ elementName ++ "\""

                isSvg : Bool
                isSvg =
                    elementName == "svg" || isSvgContext attributes

                newContext : Context
                newContext =
                    if isSvg then
                        Svg

                    else
                        context

                filteredAttributes : List String
                filteredAttributes =
                    List.concatMap
                        (\attribute ->
                            attribute
                                |> attributeToElm config
                                    (indentLevel + 1)
                                    newContext
                        )
                        attributes
            in
            ( CommaSeparator
            , (if indentLevel == 1 then
                indentation 1

               else
                indentation 0
              )
                ++ elementFunction
                ++ (indentedThingy (indentLevel + 1) identity filteredAttributes
                        ++ "\n"
                        ++ indentation (indentLevel + 1)
                        ++ "["
                        ++ (List.filterMap (nodeToElm config (indentLevel + 1) newContext) children |> join |> surroundWithSpaces)
                        ++ "]\n"
                        ++ indentation indentLevel
                   )
            )
                |> Just

        Html.Parser.Comment string ->
            Just <| ( NoSeparator, indentation indentLevel ++ "{-" ++ string ++ "-}\n" ++ indentation indentLevel )


isSvgContext : List ( String, String ) -> Bool
isSvgContext attributes =
    attributes
        |> List.any (\( key, _ ) -> key == "xmlns")


escapedString : String -> String
escapedString string =
    string
        |> String.replace "\"" "\\\""
        |> String.replace "\n" "\\n"


{-| Elm includes xmlns for svg's when you use the svg function, so we strip that off
see also namespace prefixes <https://developer.mozilla.org/en-US/docs/Web/SVG/Namespaces_Crash_Course>
-}
isNamespaceAttribute : String -> Bool
isNamespaceAttribute name =
    name == "xmlns" || (name |> String.startsWith "xmlns:")


attributeToElm : Config -> Int -> Context -> Html.Parser.Attribute -> List String
attributeToElm config indentLevel context ( name, value ) =
    if isNamespaceAttribute name then
        []

    else if name == "class" && config.useTailwindModules then
        [ TailwindClass.classAttributeToElm config context indentLevel value ]

    else if context == Svg then
        [ svgAttr config ( name, value ) ]

    else if name == "style" then
        value
            |> String.split ";"
            |> List.filter (not << String.isEmpty)
            |> List.map
                (\entry ->
                    case entry |> String.split ":" of
                        [ styleName, styleValue ] ->
                            Config.htmlAttr config "style"
                                ++ " \""
                                ++ String.trim styleName
                                ++ "\" \""
                                ++ escapedString (String.trim styleValue)
                                ++ "\""

                        _ ->
                            "<Invalid" ++ entry ++ ">"
                )

    else
        case ImplementedFunctions.lookup ImplementedFunctions.boolAttributeFunctions name of
            Just boolFunction ->
                [ Config.htmlAttr config boolFunction ++ " True" ]

            Nothing ->
                case ImplementedFunctions.lookup ImplementedFunctions.intAttributeFunctions name of
                    Just intFunction ->
                        [ Config.htmlAttr config intFunction ++ " " ++ value ]

                    Nothing ->
                        case ImplementedFunctions.lookupWithDict ImplementedFunctions.htmlAttributeDict ImplementedFunctions.htmlAttributes name of
                            Just functionName ->
                                [ Config.htmlAttr config functionName ++ " \"" ++ value ++ "\"" ]

                            Nothing ->
                                [ Config.htmlAttr config "attribute" ++ " \"" ++ name ++ "\" \"" ++ escapedString value ++ "\"" ]


svgAttr : Config -> ( String, String ) -> String
svgAttr config ( name, value ) =
    case ImplementedFunctions.lookupWithDict ImplementedFunctions.svgAttributeMap ImplementedFunctions.svgAttributes name of
        Just functionName ->
            Config.svgAttr config (ImplementedFunctions.toCamelCase functionName) ++ " \"" ++ value ++ "\""

        Nothing ->
            Config.htmlAttr config "attribute" ++ " \"" ++ name ++ "\" \"" ++ value ++ "\""


surroundWithSpaces : String -> String
surroundWithSpaces string =
    case String.right 1 string of
        "" ->
            string

        " " ->
            " " ++ string

        _ ->
            " " ++ string ++ " "
