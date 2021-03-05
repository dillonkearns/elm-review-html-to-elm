module HtmlForm exposing (result)

import Css
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (attribute, css)
import Svg.Styled as Svg exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw


result =
        form
        [ Attr.action ""
        , Attr.method "get"
        ]
          [ div []
              [ label
                [ Attr.for "name"
                ]
                  [ text "Enter your name:" ]
            , input
                [ Attr.type_ "text"
                , Attr.name "name"
                , Attr.id "name"
                , attribute "required" ""
                ]
                  []
             ]
        , div []
              [ label
                [ Attr.for "email"
                ]
                  [ text "Enter your email:" ]
            , input
                [ Attr.type_ "email"
                , Attr.name "email"
                , Attr.id "email"
                , attribute "required" ""
                ]
                  []
             ]
        , div []
              [ input
                [ Attr.type_ "submit"
                , Attr.value "Subscribe!"
                ]
                  []
             ]
         ]
    
