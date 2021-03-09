module HtmlToElmTest exposing (all)

import HtmlToElm
import Review.Test
import Test exposing (Test, describe, test)


all : Test
all =
    describe "tests"
        [ testCase "html-to-elm"
            """
import Html exposing (..)
import Html.Attributes as Attr
"""
            """view : Html msg
view = Debug.todo \"\"\"<a href="#">Link</a>\"\"\""""
            """view : Html msg
view =
        a
        [ Attr.href "#"
        ]
          [ text "Link" ]"""
        , testCase "elm-css qualified imports"
            """
import Html.Styled exposing (text)
import Html.Styled.Attributes
"""
            """view : Html msg
view = Debug.todo \"\"\"<a href="#">Link</a>\"\"\""""
            """view : Html msg
view =
        Html.Styled.a
        [ Html.Styled.Attributes.href "#"
        ]
          [ text "Link" ]"""
        , testCase "elm-css classes"
            """
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr
"""
            """view : Html msg
view = Debug.todo \"\"\"<div class="flex"></div>\"\"\""""
            """view : Html msg
view =
        div
        [ Attr.class "flex"
        ]
          []"""
        , testCase "elm-tailwind-modules classes"
            """
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr
import Tailwind.Utilities as Tw
import Tailwind.Breakpoints as Bp
"""
            """view : Html msg
view = Debug.todo \"\"\"<div class="flex"></div>\"\"\""""
            """view : Html msg
view =
        div
        [ Attr.css
            [ Tw.flex
            ]

        ]
          []"""
        ]


testCase name imports errorThing expectedBody =
    test name <|
        \_ ->
            let
                expected : String
                expected =
                    """module A exposing (..)
"""
                        ++ imports
                        ++ """

"""
                        ++ expectedBody
                        ++ """
    """
                        |> String.replace "\u{000D}" ""
            in
            """module A exposing (..)
"""
                ++ imports
                ++ """

"""
                ++ errorThing
                |> String.replace "\u{000D}" ""
                |> Review.Test.run HtmlToElm.rule
                |> Review.Test.expectErrors
                    [ Review.Test.error { message = "Here's my attempt to complete this stub", details = [ "" ], under = errorThing }
                        |> Review.Test.whenFixed expected
                    ]
