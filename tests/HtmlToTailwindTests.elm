module HtmlToTailwindTests exposing (..)

import Expect exposing (Expectation)
import Html.Parser
import Test exposing (..)


suite : Test
suite =
    describe "HtmlToTailwind"
        [ test "simple div" <|
            \() ->
                "<div></div>"
                    |> htmlToElmTailwindModules
                    |> Expect.equal "div [] []"
        , test "div with class" <|
            \() ->
                """<div class="mt-2 text-3xl font-extrabold text-gray-900"></div>"""
                    |> htmlToElmTailwindModules
                    |> Expect.equal "div [ css [ Tw.mt_2, Tw.text_3xl, Tw.font_extrabold, Tw.text_gray_900 ] ] []"
        ]


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
            "text "
                ++ textBody
                |> Just

        Html.Parser.Element elementName attributes children ->
            elementName
                ++ " ["
                ++ (List.map
                        (attributeToElm >> surroundWithSpaces)
                        attributes
                        |> String.join ", "
                   )
                ++ "] []"
                |> Just

        Html.Parser.Comment string ->
            Nothing


attributeToElm : Html.Parser.Attribute -> String
attributeToElm ( name, value ) =
    if name == "class" then
        let
            twValues =
                value
                    |> String.split " "
                    |> List.map (\className -> "Tw." ++ String.replace "-" "_" className)
        in
        "css [ " ++ String.join ", " twValues ++ " ]"

    else
        "TODO"


surroundWithSpaces : String -> String
surroundWithSpaces string =
    " " ++ string ++ " "
