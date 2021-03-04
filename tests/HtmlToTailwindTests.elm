module HtmlToTailwindTests exposing (..)

import Expect exposing (Expectation)
import HtmlToTailwind exposing (htmlToElmTailwindModules)
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
        , test "div with children" <|
            \() ->
                """<div class="flex"><div class="font-extrabold"></div></div>"""
                    |> htmlToElmTailwindModules
                    |> Expect.equal "div [ css [ Tw.flex ] ] [ div [ css [ Tw.font_extrabold ] ] [] ]"
        , test "removes whitespace-only text" <|
            \() ->
                """<div>               </div>"""
                    |> htmlToElmTailwindModules
                    |> Expect.equal """div [] []"""
        , test "handles HTML attributes besides class" <|
            \() ->
                """<a href="#"></a>"""
                    |> htmlToElmTailwindModules
                    |> Expect.equal """a [ Attr.href "#" ] []"""
        , test "strips trailing and leading whitespace" <|
            \() ->
                """<div>    NO WHITESPACE            </div>"""
                    |> htmlToElmTailwindModules
                    |> Expect.equal """div [] [ text "NO WHITESPACE" ]"""
        , describe "Elm name normalization"
            [ test "negative" <|
                \() ->
                    """<div class="-mt-8"></div>"""
                        |> htmlToElmTailwindModules
                        |> Expect.equal "div [ css [ Tw.neg_mt_8 ] ] []"
            , test "fractions" <|
                \() ->
                    """<div class="h-1/2"></div>"""
                        |> htmlToElmTailwindModules
                        |> Expect.equal "div [ css [ Tw.h_1over2 ] ] []"
            ]
        , describe "comments"
            [ test "includes comments" <|
                \() ->
                    """<!-- Outer comment -->
                    <div>
                        <!-- Inner comment 1 -->
                        <!-- Inner comment 2 -->
                        <span>1</span>
                        <span>2</span>
                        <span>3</span>
                    </div>"""
                        |> htmlToElmTailwindModules
                        |> Expect.equal """{- Outer comment -}
    div [] [ {- Inner comment 1 -}
    {- Inner comment 2 -}
    span [] [ text "1" ], span [] [ text "2" ], span [] [ text "3" ] ]"""
            ]
        ]
