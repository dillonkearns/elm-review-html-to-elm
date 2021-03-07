module Style exposing (main)

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
    main_
    []
    [ div
        [ Attr.style "transition-duration" "1.5s"
        , Attr.style "line-height" "1.5"
        , Attr.style "margin" "15px"
        ]
        []
    , div
        [ Attr.style "transition-duration" "1.5s"
        , Attr.style "line-height" "1.5"
        , Attr.style "margin" "15px"
        ]
        []
    , div [ Attr.style "line-height" "1.5" ] []
    , div [ Attr.style "line-height" "1.5" ] []
    ]
