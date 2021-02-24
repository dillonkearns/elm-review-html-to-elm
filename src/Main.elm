module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes
import Html.Events exposing (onClick)
import HtmlToTailwind


type alias Model =
    { count : String }


initialModel : Model
initialModel =
    { count = "" }


type Msg
    = OnInput String


update : Msg -> Model -> Model
update msg model =
    case msg of
        OnInput newInput ->
            { model | count = newInput }


view : Model -> Html Msg
view model =
    div []
        [ Html.textarea
            [ Html.Events.onInput OnInput
            , Html.Attributes.value model.count
            ]
            []
        , div [] [ text <| HtmlToTailwind.htmlToElmTailwindModules model.count ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
