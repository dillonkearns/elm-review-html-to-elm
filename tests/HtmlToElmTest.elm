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
                    expected : String
                    expected =
                        """module A exposing (..)

import Html


view : Html msg
view =
        div []
          []
    
"""
                            |> String.replace "\u{000D}" ""
                in
                """module A exposing (..)

import Html


view : Html msg
view = Debug.todo "<div></div>"
"""
                    |> String.replace "\u{000D}" ""
                    |> Review.Test.run HtmlToElm.rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error { message = "Here's my attempt to complete this stub", details = [ "" ], under = "view : Html msg\nview = Debug.todo \"<div></div>\"" }
                            |> Review.Test.whenFixed expected
                        ]
        ]
