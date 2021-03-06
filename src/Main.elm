module Main exposing (main)

import Browser
import Css
import Css.Global
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (attribute, css)
import Html.Styled.Events as Events
import HtmlToTailwind
import Svg.Styled as Svg
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw


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



--view : Model -> Html.Html Msg


view model =
    div
        [ Attr.style "padding" "20px"
        ]
        [ Html.textarea
            [ Events.onInput OnInput
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
        , settingsPanel
        ]
        |> Html.toUnstyled


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }


example { moduleName, placeholder } =
    div
        [ css
            [ Tw.mb_4
            , Tw.flex
            , Tw.items_center
            ]
        ]
        [ div [ css [ Tw.flex_1 ] ]
            [ p
                [ css
                    [ Tw.font_mono
                    , Tw.items_center
                    , Tw.pr_2

                    --, Tw.text_right
                    ]
                ]
                [ text <| "import " ++ moduleName ]
            ]
        , div [ css [ Tw.flex_1 ] ]
            [ inputWithInset
                { placeholder = placeholder
                , id = "html-tag-import"
                , prefix = " as "
                , paddingLeft = Tw.pl_9
                }
            ]
        , div [ css [ Tw.flex_1 ] ]
            [ inputWithInsets
                { placeholder = ".."
                , id = "html-tag-expose"
                , prefix = " exposing ("
                , paddingLeft = Tw.pl_28
                }
            ]
        ]


settingsPanel =
    main_
        [ css [ Tw.relative ] ]
        [ {--}
          Css.Global.global Tw.globalStyles
        , example { moduleName = "Html", placeholder = "Html" }
        , example { moduleName = "Html.Attributes", placeholder = "Attr" }
        , example { moduleName = "Svg", placeholder = "Svg" }
        , example { moduleName = "Svg.Attributes", placeholder = "SvgAttr" }
        , example { moduleName = "Tailwind.Utilities", placeholder = "Tw" }
        , example { moduleName = "Tailwind.Breakpoints", placeholder = "Bp" }
        ]


inputWithInset { placeholder, id, prefix, paddingLeft } =
    div
        [ css
            [ Tw.mt_1
            , Tw.relative
            , Tw.rounded_md
            , Tw.shadow_sm
            ]
        ]
        [ div
            [ css
                [ Tw.absolute
                , Tw.inset_y_0
                , Tw.left_0
                , Tw.pl_3
                , Tw.flex
                , Tw.items_center
                , Tw.pointer_events_none
                ]
            ]
            [ span
                [ css
                    [ Tw.text_gray_500
                    , Css.focus
                        [ Tw.text_blue_500 |> Css.important
                        ]
                    , Bp.sm
                        [ Tw.text_sm
                        ]
                    ]
                ]
                [ text prefix ]
            ]
        , input
            [ Attr.type_ "text"
            , Attr.name id
            , Attr.id id
            , Attr.placeholder placeholder
            , css
                [ Tw.font_mono
                , Tw.border_0 |> Css.important
                , Tw.border_b_2 |> Css.important

                --, Tw.border_b_8
                --,  Tw.border_blue_800
                --, Tw.border
                --, Tw.border_transparent |> Css.important
                --, Tw.border_gray_300
                --, Tw.rounded_md
                --, Tw.shadow_sm
                --, Tw.py_2
                --, Tw.px_3
                --, Css.focus
                --    [ Tw.outline_none
                --    , Tw.ring_blue_500
                --    , Tw.border_blue_500
                --    ]
                --, Bp.sm
                --    [ Tw.text_sm
                --    ]
                , Tw.block |> Css.important
                , Tw.w_full |> Css.important

                --, Tw.pl_9 |> Css.important
                , paddingLeft |> Css.important
                , Tw.pr_12 |> Css.important
                , Tw.outline_none |> Css.important
                , Tw.ring_0 |> Css.important
                , Tw.ring_transparent |> Css.important

                --, Tw.border_gray_400 |> Css.important
                --, Tw.rounded_md |> Css.important
                , Css.focus
                    [ --Tw.ring_blue_500
                      --Tw.ring_b_b
                      --, Tw.border_blue_500
                      --, Tw.blue_500_b
                      Css.borderBottomColor (Css.rgb 59 130 246) |> Css.important

                    --, Tw.border_0 |> Css.important
                    --, Tw.border_b_4 |> Css.important
                    ]
                , Bp.sm
                    [ Tw.text_sm
                    ]
                ]
            ]
            []
        ]


inputWithInsets { placeholder, id, prefix, paddingLeft } =
    div
        [ css
            [ Tw.mt_1
            , Tw.relative
            , Tw.rounded_md
            , Tw.shadow_sm
            ]
        ]
        [ div
            [ css
                [ Tw.absolute
                , Tw.inset_y_0
                , Tw.left_0
                , Tw.pl_3
                , Tw.flex
                , Tw.items_center
                , Tw.pointer_events_none
                ]
            ]
            [ span
                [ css
                    [ Tw.text_gray_500
                    , Css.focus
                        [ Tw.text_blue_500 |> Css.important
                        ]
                    , Bp.sm
                        [ Tw.text_sm
                        ]
                    ]
                ]
                [ text prefix ]
            ]
        , input
            [ Attr.type_ "text"
            , Attr.name id
            , Attr.id id
            , Attr.placeholder placeholder
            , css
                [ Tw.font_mono
                , Tw.border_0 |> Css.important
                , Tw.border_b_2 |> Css.important

                --, Tw.border_b_8
                --,  Tw.border_blue_800
                --, Tw.border
                --, Tw.border_transparent |> Css.important
                --, Tw.border_gray_300
                --, Tw.rounded_md
                --, Tw.shadow_sm
                --, Tw.py_2
                --, Tw.px_3
                --, Css.focus
                --    [ Tw.outline_none
                --    , Tw.ring_blue_500
                --    , Tw.border_blue_500
                --    ]
                --, Bp.sm
                --    [ Tw.text_sm
                --    ]
                , Tw.block |> Css.important
                , Tw.w_full |> Css.important

                --, Tw.pl_9 |> Css.important
                , paddingLeft |> Css.important
                , Tw.pr_12 |> Css.important
                , Tw.outline_none |> Css.important
                , Tw.ring_0 |> Css.important
                , Tw.ring_transparent |> Css.important

                --, Tw.border_gray_400 |> Css.important
                --, Tw.rounded_md |> Css.important
                , Css.focus
                    [ --Tw.ring_blue_500
                      --Tw.ring_b_b
                      --, Tw.border_blue_500
                      --, Tw.blue_500_b
                      Css.borderBottomColor (Css.rgb 59 130 246) |> Css.important

                    --, Tw.border_0 |> Css.important
                    --, Tw.border_b_4 |> Css.important
                    ]
                , Bp.sm
                    [ Tw.text_sm
                    ]
                ]
            ]
            []
        , div
            [ css
                [ Tw.absolute
                , Tw.inset_y_0
                , Tw.right_0
                , Tw.pr_3
                , Tw.flex
                , Tw.items_center
                , Tw.pointer_events_none
                ]
            ]
            [ span
                [ css
                    [ Tw.text_gray_500
                    , Bp.sm
                        [ Tw.text_sm
                        ]
                    ]
                , Attr.id "price-currency"
                ]
                [ text ")" ]
            ]
        ]
