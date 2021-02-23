module HtmlToTailwindTests exposing (..)

import Dict
import Dict.Extra
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
        , test "div with breakpoints" <|
            \() ->
                """<div class="flex flex-col md:flex-row"></div>"""
                    |> htmlToElmTailwindModules
                    |> Expect.equal "div [ css [ Tw.flex, Tw.flex_col, Bp.md [ Tw.flex_row ] ] ] []"
        , test "div with multiple breakpoints" <|
            \() ->
                """<div class="flex md:font-extrabold flex-col md:flex-row"></div>"""
                    |> htmlToElmTailwindModules
                    |> Expect.equal "div [ css [ Tw.flex, Tw.flex_col, Bp.md [ Tw.font_extrabold, Tw.flex_row ] ] ] []"
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
    " " ++ string ++ " "
