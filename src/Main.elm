module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes as Attr
import Html.Events exposing (onClick)
import HtmlToTailwind


type alias Model =
    { htmlInput : String }


initialModel : Model
initialModel =
    { htmlInput = "" }


type Msg
    = OnInput String


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnInput newInput ->
            { model | htmlInput = newInput }


view : Model -> Html Msg
view model =
    div
        [ Attr.style "padding" "20px"
        ]
        [ Html.textarea
            [ Html.Events.onInput OnInput
            , Attr.value model.htmlInput
            , Attr.style "width" "100%"
            , Attr.style "height" "200px"
            ]
            []
        , Html.pre []
            [ Html.code []
                [ model.htmlInput
                    |> HtmlToTailwind.htmlToElmTailwindModules
                    |> text
                ]
            ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
