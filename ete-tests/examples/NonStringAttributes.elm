module NonStringAttributes exposing (main)

import Css
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (attribute, css)
import Svg.Styled as Svg exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import Tailwind.Theme as Theme


main =
    Html.toUnstyled result


result =
    main_ []
        [ form
            [ Attr.novalidate True
            ]
            [ input
                [ Attr.readonly True
                , Attr.tabindex 2
                , Attr.height 100
                , Attr.width 100
                , Attr.minlength 2
                , Attr.maxlength 100
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
            , input
                [ Attr.type_ "checkbox"
                , Attr.id "scales"
                , Attr.name "scales"
                , Attr.checked True
                ]
                []
            , label
                [ Attr.for "story"
                ]
                [ text "Tell us your story:" ]
            , textarea
                [ Attr.id "story"
                , Attr.name "story"
                , Attr.rows 5
                , Attr.cols 33
                ]
                [ text " It was a dark and stormy night... " ]
            ]
        ,         {- The second value will be selected initially -}
        select
            [ Attr.name "choice"
            , Attr.size 2
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
            [ Attr.start 100
            , Attr.reversed True
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
            , Attr.src "/media/cc0-videos/friday.mp4"
            ]
            [ track
                [ Attr.default True
                , Attr.kind "captions"
                , Attr.srclang "en"
                , Attr.src "/media/examples/friday.vtt"
                ]
                []
            ]
        , table []
            [ caption []
                [ text "Alien football stars" ]
            , tr []
                [ th
                    [ Attr.scope "col"
                    , Attr.colspan 2
                    , Attr.rowspan 2
                    ]
                    [ text "Player" ]
                , th
                    [ Attr.scope "col"
                    ]
                    [ text "Gloobles" ]
                , th
                    [ Attr.scope "col"
                    ]
                    [ text "Za'taak" ]
                ]
            , tr []
                [ th
                    [ Attr.scope "row"
                    ]
                    [ text "TR-7" ]
                , td []
                    [ text "7" ]
                , td []
                    [ text "4,569" ]
                ]
            , tr []
                [ th
                    [ Attr.scope "row"
                    ]
                    [ text "Khiresh Odo" ]
                , td []
                    [ text "7" ]
                , td []
                    [ text "7,223" ]
                ]
            , tr []
                [ th
                    [ Attr.scope "row"
                    ]
                    [ text "Mia Oolong" ]
                , td []
                    [ text "9" ]
                , td []
                    [ text "6,219" ]
                ]
            ]
        , table []
            [ colgroup []
                [ col
                    [ attribute "span" "2"
                    , Attr.style "background-color" "red"
                    ]
                    []
                , col
                    [ Attr.style "background-color" "yellow"
                    ]
                    []
                ]
            , tr []
                [ th []
                    [ text "ISBN" ]
                , th []
                    [ text "Title" ]
                , th []
                    [ text "Price" ]
                ]
            , tr []
                [ td []
                    [ text "3476896" ]
                , td []
                    [ text "My first HTML" ]
                , td []
                    [ text "$53" ]
                ]
            ]
        ]
    
