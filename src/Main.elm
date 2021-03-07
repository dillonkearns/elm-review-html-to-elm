port module Main exposing (main)

import Browser
import Config exposing (Config)
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


port copyGeneratedCode : () -> Cmd msg


type alias Model =
    { htmlInput : String
    , config : Config
    , showSettings : Bool
    }


initialModel : Model
initialModel =
    { htmlInput = """<a href="#" />"""
    , config = Config.default
    , showSettings = False
    }


type Msg
    = OnInput String
    | SetHtmlAlias String
    | SetHtmlAttrAlias String
    | SetSvgAlias String
    | SetSvgAttrAlias String
    | SetTwAlias String
    | SetBpAlias String
    | SetHtmlExposing String
    | SetHtmlAttrExposing String
    | SetSvgExposing String
    | SetSvgAttrExposing String
    | SetTwExposing String
    | SetBpExposing String
    | ToggleShowSettings
    | UseTailwindClasses
    | CopyGeneratedCode


noCmd model =
    ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnInput newInput ->
            { model | htmlInput = newInput }
                |> noCmd

        SetHtmlAlias string ->
            { model
                | config = Config.updateHtmlAlias model.config string
            }
                |> noCmd

        SetHtmlAttrAlias string ->
            { model
                | config = Config.updateHtmlAttrAlias model.config string
            }
                |> noCmd

        SetSvgAlias string ->
            { model
                | config = Config.updateSvgAlias model.config string
            }
                |> noCmd

        SetSvgAttrAlias string ->
            { model
                | config = Config.updateSvgAttrAlias model.config string
            }
                |> noCmd

        SetTwAlias string ->
            { model
                | config = Config.updateTwAlias model.config string
            }
                |> noCmd

        SetBpAlias string ->
            { model
                | config = Config.updateBpAlias model.config string
            }
                |> noCmd

        SetHtmlExposing string ->
            { model
                | config = Config.updateHtmlExposing model.config string
            }
                |> noCmd

        SetHtmlAttrExposing string ->
            { model
                | config = Config.updateHtmlAttrExposing model.config string
            }
                |> noCmd

        SetSvgExposing string ->
            { model
                | config = Config.updateSvgExposing model.config string
            }
                |> noCmd

        SetSvgAttrExposing string ->
            { model
                | config = Config.updateSvgAttrExposing model.config string
            }
                |> noCmd

        SetTwExposing string ->
            { model
                | config = Config.updateTwExposing model.config string
            }
                |> noCmd

        SetBpExposing string ->
            { model
                | config = Config.updateBpExposing model.config string
            }
                |> noCmd

        ToggleShowSettings ->
            { model
                | showSettings = not model.showSettings
            }
                |> noCmd

        UseTailwindClasses ->
            { model
                | config = Config.toggleUseTailwindClasses model.config
            }
                |> noCmd

        CopyGeneratedCode ->
            ( model
            , copyGeneratedCode ()
            )



--view : Model -> Html.Html Msg


view model =
    div
        [ css
            [ Tw.h_screen
            , Tw.flex
            , Tw.flex_col
            ]
        ]
        [ Css.Global.global Tw.globalStyles
        , navbar model
        , div
            [ css
                [ Tw.flex
                , Tw.h_full
                ]
            ]
            [ div
                [ css
                    [ Tw.flex_1
                    ]
                ]
                [ div
                    [ css
                        [ if model.showSettings then
                            Css.batch []

                          else
                            Tw.hidden
                        ]
                    ]
                    [ settingsPanel ]
                , Html.textarea
                    [ Events.onInput OnInput
                    , Attr.value model.htmlInput
                    , Attr.spellcheck False
                    , Attr.autocomplete False
                    , css
                        [ Tw.h_full
                        , Tw.w_full
                        ]
                    ]
                    []
                ]
            , Html.textarea
                [ css
                    [ Tw.font_mono

                    --, Tw.w_full
                    , Tw.flex_1
                    ]
                , Attr.id "generated-elm"
                ]
                [ model.htmlInput
                    |> HtmlToTailwind.htmlToElmTailwindModules model.config
                    |> text
                ]
            ]

        --, settingsPanel
        ]
        |> Html.toUnstyled


main : Program () Model Msg
main =
    Browser.document
        { init = \_ -> initialModel |> noCmd
        , view = \model -> { title = "html-to-elm", body = [ view model ] }
        , update = update
        , subscriptions = \_ -> Sub.none
        }


navbar : Model -> Html Msg
navbar model =
    nav
        [ css
            [ Tw.bg_gray_800
            ]
        ]
        [ div
            [ css
                [ Tw.max_w_7xl
                , Tw.mx_auto
                , Tw.px_2
                , Bp.lg
                    [ Tw.px_8
                    ]
                , Bp.sm
                    [ Tw.px_6
                    ]
                ]
            ]
            [ div
                [ css
                    [ Tw.relative
                    , Tw.flex
                    , Tw.items_center
                    , Tw.justify_between
                    , Tw.h_16
                    ]
                ]
                [ h2
                    [ css
                        [ Tw.text_white
                        , Tw.text_lg
                        , Tw.font_bold
                        , Tw.pl_2
                        ]
                    ]
                    [ text "html-to-elm.com"
                    ]
                , div
                    [ css
                        [ Tw.flex
                        , Tw.space_x_3
                        ]
                    ]
                    [ span
                        [ css
                            [ Tw.text_gray_300
                            ]
                        ]
                        [ text "Use "
                        , a
                            [ Attr.href "https://github.com/matheus23/elm-tailwind-modules"
                            , Attr.target "_blank"
                            , Attr.rel "noopener"
                            , css
                                [ Tw.text_blue_300
                                , Css.hover
                                    [ Tw.text_blue_500
                                    ]
                                ]
                            ]
                            [ text "tailwind classes" ]
                        ]
                    , div [] [ toggle UseTailwindClasses model.config.useTailwindModules ]
                    ]
                , button
                    [ Events.onClick ToggleShowSettings
                    , css
                        [ Tw.flex
                        , Tw.space_x_2
                        , Tw.items_center
                        , Tw.text_gray_300
                        , Tw.px_3
                        , Tw.py_2
                        , Tw.rounded_md
                        , Tw.text_sm
                        , Tw.font_medium
                        , Css.hover
                            [ Tw.bg_gray_700
                            , Tw.text_white
                            ]
                        ]
                    ]
                    [ div
                        []
                        [ text "Settings" ]
                    , settingsIcon
                    ]
                , button
                    [ Events.onClick CopyGeneratedCode
                    , css
                        [ Tw.flex
                        , Tw.space_x_2
                        , Tw.items_center
                        , Tw.text_gray_300
                        , Tw.px_3
                        , Tw.py_2
                        , Tw.rounded_md
                        , Tw.text_sm
                        , Tw.font_medium
                        , Css.hover
                            [ Tw.bg_gray_700
                            , Tw.text_white
                            ]
                        ]
                    ]
                    [ div
                        []
                        [ text "Copy" ]
                    , copyIcon
                    ]
                ]
            ]
        ]


example { moduleName, placeholder, onInputAlias, onInputExposing } =
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
                , onInput = onInputAlias
                }
            ]
        , div [ css [ Tw.flex_1 ] ]
            [ inputWithInsets
                { placeholder = ".."
                , id = "html-tag-expose"
                , prefix = " exposing ("
                , paddingLeft = Tw.pl_28
                , onInput = onInputExposing
                }
            ]
        ]


settingsPanel =
    main_
        [ css [ Tw.relative ] ]
        [ {--}
          example { moduleName = "Html", placeholder = "Html", onInputAlias = SetHtmlAlias, onInputExposing = SetHtmlExposing }
        , example { moduleName = "Html.Attributes", placeholder = "Attr", onInputAlias = SetHtmlAttrAlias, onInputExposing = SetHtmlAttrExposing }
        , example { moduleName = "Svg", placeholder = "Svg", onInputAlias = SetSvgAlias, onInputExposing = SetSvgExposing }
        , example { moduleName = "Svg.Attributes", placeholder = "SvgAttr", onInputAlias = SetSvgAttrAlias, onInputExposing = SetSvgAttrExposing }
        , example { moduleName = "Tailwind.Utilities", placeholder = "Tw", onInputAlias = SetTwAlias, onInputExposing = SetTwExposing }
        , example { moduleName = "Tailwind.Breakpoints", placeholder = "Bp", onInputAlias = SetBpAlias, onInputExposing = SetBpExposing }
        ]


inputWithInset { placeholder, id, prefix, paddingLeft, onInput } =
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
            , Events.onInput onInput
            , Attr.spellcheck False
            , Attr.autocomplete False
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
                      Tw.border_blue_500

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


inputWithInsets { placeholder, id, prefix, paddingLeft, onInput } =
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
            , Events.onInput onInput
            , Attr.spellcheck False
            , Attr.autocomplete False
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


settingsIcon : Html msg
settingsIcon =
    Svg.svg
        [ SvgAttr.fill "none"
        , SvgAttr.viewBox "0 0 24 24"
        , SvgAttr.stroke "currentColor"
        , SvgAttr.css [ Tw.h_6 ]
        ]
        [ Svg.path
            [ SvgAttr.strokeLinecap "round"
            , SvgAttr.strokeLinejoin "round"
            , SvgAttr.strokeWidth "2"
            , SvgAttr.d "M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"
            ]
            []
        ]


toggle toggleMsg enabled =
    Html.button
        [ Attr.type_ "button"
        , Events.onClick UseTailwindClasses
        , Attr.css
            [ if enabled then
                Tw.bg_blue_600

              else
                Tw.bg_gray_200
            , Tw.relative
            , Tw.inline_flex
            , Tw.flex_shrink_0
            , Tw.h_6
            , Tw.w_11
            , Tw.border_2
            , Tw.border_transparent
            , Tw.rounded_full
            , Tw.cursor_pointer
            , Tw.transition_colors
            , Tw.ease_in_out
            , Tw.duration_200
            , Css.focus
                [ Tw.outline_none
                , Tw.ring_2
                , Tw.ring_offset_2
                , Tw.ring_blue_500
                ]
            ]
        , Attr.attribute "aria-pressed" "false"
        ]
        [ Html.span
            [ Attr.css
                [ Tw.sr_only
                ]
            ]
            [ Html.text "Use setting" ]
        , {- Enabled: "translate-x-5", Not Enabled: "translate-x-0" -}
          Html.span
            [ Attr.attribute "aria-hidden" "true"
            , Attr.css
                [ if enabled then
                    Tw.translate_x_5 |> Css.important

                  else
                    Tw.translate_x_0 |> Css.important
                , Tw.pointer_events_none
                , Tw.inline_block
                , Tw.h_5
                , Tw.w_5
                , Tw.rounded_full
                , Tw.bg_white
                , Tw.shadow
                , Tw.transform
                , Tw.ring_0
                , Tw.transition
                , Tw.ease_in_out
                , Tw.duration_200
                ]
            ]
            []
        ]


copyIcon : Html msg
copyIcon =
    Svg.svg
        [ SvgAttr.fill "none"
        , SvgAttr.viewBox "0 0 24 24"
        , SvgAttr.stroke "currentColor"
        , SvgAttr.css [ Tw.h_6 ]
        ]
        [ Svg.path
            [ SvgAttr.strokeLinecap "round"
            , SvgAttr.strokeLinejoin "round"
            , SvgAttr.strokeWidth "2"
            , SvgAttr.d "M8 5H6a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2v-1M8 5a2 2 0 002 2h2a2 2 0 002-2M8 5a2 2 0 012-2h2a2 2 0 012 2m0 0h2a2 2 0 012 2v3m2 4H10m0 0l3-3m-3 3l3 3"
            ]
            []
        ]
