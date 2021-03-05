module NonStringAttributes exposing (result)

import Css
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (attribute, css)
import Svg.Styled as Svg exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw


result =
        main_ []
          [ form
            [ Attr.novalidate True
            ]
              [ input
                [ Attr.readonly True
                , attribute "tabindex" "2"
                , Attr.disabled True
                , Attr.autofocus True
                ]
                  []
            , input
                [ Attr.type_ "email"
                , Attr.multiple True
                ]
                  []
            , input
                [ Attr.type_ "text"
                , Attr.required True
                ]
                  []
             ]
        ,         {- The second value will be selected initially -}
        select
            [ Attr.name "choice"
            ]
              [ option
                [ Attr.value "first"
                ]
                  [ text "First Value" ]
            , option
                [ Attr.value "second"
                , Attr.selected True
                ]
                  [ text "Second Value" ]
            , option
                [ Attr.value "third"
                ]
                  [ text "Third Value" ]
             ]
        , img
            [ Attr.ismap True
            ]
              []
        , ol
            [ Attr.reversed True
            ]
              [ li []
                  [ text "1" ]
            , li []
                  [ text "2" ]
            , li []
                  [ text "3" ]
             ]
        , div
            [ Attr.hidden True
            ]
              []
        , div
            [ Attr.contenteditable True
            , Attr.spellcheck True
            ]
              [ text "Hello" ]
        , video
            [ Attr.autoplay True
            , Attr.controls True
            , Attr.loop True
            ]
              [ track
                [ Attr.default True
                ]
                  []
             ]
         ]
    
