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
                ++ " [] []"
                |> Just

        Html.Parser.Comment string ->
            Nothing
