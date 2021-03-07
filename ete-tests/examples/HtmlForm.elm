module HtmlForm exposing (main)

import Css
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (attribute, css)
import Svg.Styled as Svg exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw


main =
    Html.toUnstyled result


result =
    form
    [ Attr.action "", Attr.method "get" ]
    [ div
        []
        [ label [ Attr.for "name" ] [ text "Enter your name:" ]
        , input
            [ Attr.type_ "text"
            , Attr.name "name"
            , Attr.id "name"
            , Attr.required True
            ]
            []
        ]
    , div
        []
        [ label [ Attr.for "email" ] [ text "Enter your email:" ]
        , input
            [ Attr.type_ "email"
            , Attr.name "email"
            , Attr.id "email"
            , Attr.required True
            ]
            []
        ]
    , div [] [ input [ Attr.type_ "submit", Attr.value "Subscribe!" ] [] ]
    ]
