module HtmlToElmTest exposing (all)

import HtmlToElm
import Review.Test
import Test exposing (Test, describe, test)


all : Test
all =
    describe "tests"
        [ test "html-to-elm" <|
            \_ ->
                let
                    errorThing =
                        """view : Html msg
view = Debug.todo \"\"\"<a href="#">Link</a>\"\"\""""

                    expected : String
                    expected =
                        """module A exposing (..)

import Html exposing (..)
import Html.Attributes as Attr


view : Html msg
view =
        a
        [ Attr.href "#"
        ]
          [ text "Link" ]
    """
                            |> String.replace "\u{000D}" ""
                in
                """module A exposing (..)

import Html exposing (..)
import Html.Attributes as Attr


"""
                    ++ errorThing
                    |> String.replace "\u{000D}" ""
                    |> Review.Test.run HtmlToElm.rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error { message = "Here's my attempt to complete this stub", details = [ "" ], under = errorThing }
                            |> Review.Test.whenFixed expected
                        ]
        ]
