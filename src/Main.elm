module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes
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
    div []
        [ Html.textarea
            [ Html.Events.onInput OnInput
            , Html.Attributes.value model.htmlInput
            ]
            []
        , div [] [ text <| HtmlToTailwind.htmlToElmTailwindModules model.htmlInput ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
