port module Main exposing (main)

import Browser
import Codec
import Config exposing (Config)
import Css
import Css.Global
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr exposing (attribute, css)
import Html.Styled.Events as Events
import HtmlToTailwind
import Json.Decode
import Json.Encode
import Svg.Styled as Svg
import Svg.Styled.Attributes as SvgAttr
import SyntaxHighlight
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw


port copyGeneratedCode : String -> Cmd msg


port saveConfig : String -> Cmd msg


type alias Model =
    { htmlInput : String
    , config : Config
    , showSettings : Bool
    }


init : Maybe String -> ( Model, Cmd msg )
init configJsonString =
    ( { htmlInput = """<a href="/">Home Page</a>"""
      , config =
            configJsonString
                |> Result.fromMaybe "No initial config"
                |> Result.andThen
                    (\jsonString ->
                        Codec.decodeString Config.codec jsonString
                            |> Result.mapError Json.Decode.errorToString
                    )
                |> Result.withDefault Config.default
      , showSettings = False
      }
    , Cmd.none
    )


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


noCmd : Model -> ( Model, Cmd msg )
noCmd model =
    ( model
    , saveConfig (Codec.encodeToString 0 Config.codec model.config)
    )


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
            , model.htmlInput
                |> HtmlToTailwind.htmlToElmTailwindModules model.config
                |> copyGeneratedCode
            )


view : Model -> Html.Html Msg
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
        , main_
            [ css
                [ Tw.flex
                , Tw.flex_col
                , Tw.flex_grow
                , Tw.overflow_hidden
                , Bp.sm
                    [ Tw.flex_row
                    ]
                ]
            ]
            [ div
                [ css
                    [ if model.showSettings then
                        Css.batch
                            [ Tw.flex
                            , Bp.sm
                                [ Tw.hidden
                                ]
                            ]

                      else
                        Tw.hidden
                    ]
                ]
                [ settingsPanel model ]
            , div
                [ css
                    [ Tw.flex
                    , Tw.flex_col
                    , Bp.sm [ Tw.w_1over2 ]
                    ]
                ]
                [ div
                    [ css
                        [ if model.showSettings then
                            Css.batch
                                [ Css.batch
                                    [ Tw.hidden
                                    , Bp.sm
                                        [ Tw.flex
                                        ]
                                    ]
                                ]

                          else
                            Tw.hidden
                        ]
                    ]
                    [ settingsPanel model ]
                , div
                    [ css
                        [ Tw.w_full
                        , Tw.flex_grow
                        , Tw.flex
                        , Tw.flex_col
                        ]
                    ]
                    [ label
                        [ css
                            [ Tw.p_2
                            , Tw.font_bold
                            ]
                        , Attr.for "input-html"
                        ]
                        [ text "Input HTML" ]
                    , textarea
                        [ Events.onInput OnInput
                        , Attr.value model.htmlInput
                        , Attr.spellcheck False
                        , Attr.autocomplete False
                        , Attr.name "input-html"
                        , Attr.id "input-html"
                        , css
                            [ Tw.w_full
                            , Tw.flex_grow
                            ]
                        ]
                        []
                    ]
                ]
            , div
                [ css
                    [ Bp.sm [ Tw.w_1over2 ]
                    , Tw.flex_grow
                    , Tw.flex
                    , Tw.flex_col
                    ]
                ]
                [ label
                    [ css
                        [ Tw.p_2
                        , Tw.font_bold
                        ]
                    ]
                    [ text "Output Elm" ]
                , model.htmlInput
                    |> HtmlToTailwind.htmlToElmTailwindModules model.config
                    |> SyntaxHighlight.elm
                    |> Result.map (SyntaxHighlight.toBlockHtml Nothing)
                    |> Result.map Html.Styled.fromUnstyled
                    |> Result.withDefault
                        (pre
                            []
                            [ code []
                                [ model.htmlInput
                                    |> HtmlToTailwind.htmlToElmTailwindModules model.config
                                    |> text
                                ]
                            ]
                        )
                ]
            ]
        , footerView
        ]
        |> toUnstyled


main : Program (Maybe String) Model Msg
main =
    Browser.document
        { init = init
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
                [ div
                    [ css
                        [ Tw.space_x_4
                        , Tw.items_center
                        , Bp.sm [ Tw.flex ]
                        , Tw.hidden
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
                    , a
                        [ Attr.href "https://github.com/dillonkearns/elm-review-html-to-elm/tree/master/site"
                        , Attr.target "_blank"
                        , Attr.rel "noopener"
                        ]
                        [ img
                            [ Attr.alt "GitHub Repo stars"
                            , Attr.src "https://img.shields.io/github/stars/dillonkearns/elm-review-html-to-elm?label=Star&style=social"
                            ]
                            []
                        ]
                    ]
                , div
                    [ css
                        [ Tw.flex
                        , Tw.items_center
                        ]
                    ]
                    [ div
                        [ css
                            [ Tw.flex
                            , Tw.space_x_3
                            , Tw.items_center
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
        ]


example :
    Model
    -> { moduleName : String, placeholder : String, onInputAlias : String -> Msg, onInputExposing : String -> Msg }
    -> (Config -> ( String, Config.Exposing ))
    -> Html Msg
example model { moduleName, placeholder, onInputAlias, onInputExposing } getter =
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
                , value = getter model.config |> Tuple.first
                }
            ]
        , div [ css [ Tw.flex_1 ] ]
            [ inputWithInsets
                { placeholder = ""
                , id = "html-tag-expose"
                , prefix = " exposing ("
                , paddingLeft = Tw.pl_28
                , onInput = onInputExposing
                , value = getter model.config |> Config.getExposingString
                }
            ]
        ]


settingsPanel : Model -> Html Msg
settingsPanel model =
    div
        [ css
            [ Tw.relative
            , Tw.shadow_lg
            , Tw.p_4
            , Tw.bg_white
            ]
        ]
        [ {--}
          example model
            { moduleName = "Html", placeholder = "Html", onInputAlias = SetHtmlAlias, onInputExposing = SetHtmlExposing }
            .html
        , example model
            { moduleName = "Html.Attributes", placeholder = "Attr", onInputAlias = SetHtmlAttrAlias, onInputExposing = SetHtmlAttrExposing }
            .htmlAttr
        , example model
            { moduleName = "Svg", placeholder = "Svg", onInputAlias = SetSvgAlias, onInputExposing = SetSvgExposing }
            .svg
        , example model
            { moduleName = "Svg.Attributes", placeholder = "SvgAttr", onInputAlias = SetSvgAttrAlias, onInputExposing = SetSvgAttrExposing }
            .svgAttr
        , if model.config.useTailwindModules then
            example model
                { moduleName = "Tailwind.Utilities", placeholder = "Tw", onInputAlias = SetTwAlias, onInputExposing = SetTwExposing }
                .tw

          else
            text ""
        , if model.config.useTailwindModules then
            example model
                { moduleName = "Tailwind.Breakpoints", placeholder = "Bp", onInputAlias = SetBpAlias, onInputExposing = SetBpExposing }
                .bp

          else
            text ""
        ]


inputWithInset :
    { placeholder : String
    , id : String
    , prefix : String
    , paddingLeft : Css.Style
    , onInput : String -> Msg
    , value : String
    }
    -> Html Msg
inputWithInset { placeholder, id, prefix, paddingLeft, onInput, value } =
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
            , Attr.value value
            , css
                [ Tw.font_mono
                , Tw.border_0 |> Css.important
                , Tw.border_b_2 |> Css.important
                , Tw.block |> Css.important
                , Tw.w_full |> Css.important
                , paddingLeft |> Css.important
                , Tw.pr_12 |> Css.important
                , Tw.outline_none |> Css.important
                , Tw.ring_0 |> Css.important
                , Tw.ring_transparent |> Css.important
                , Css.focus
                    [ Tw.border_blue_500
                    ]
                , Bp.sm
                    [ Tw.text_sm
                    ]
                ]
            ]
            []
        ]


inputWithInsets :
    { placeholder : String
    , id : String
    , prefix : String
    , paddingLeft : Css.Style
    , onInput : String -> Msg
    , value : String
    }
    -> Html Msg
inputWithInsets { placeholder, id, prefix, paddingLeft, onInput, value } =
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
            , Attr.value value
            , css
                [ Tw.font_mono
                , Tw.border_0 |> Css.important
                , Tw.border_b_2 |> Css.important
                , Tw.block |> Css.important
                , Tw.w_full |> Css.important
                , paddingLeft |> Css.important
                , Tw.pr_12 |> Css.important
                , Tw.outline_none |> Css.important
                , Tw.ring_0 |> Css.important
                , Tw.ring_transparent |> Css.important
                , Css.focus
                    [ Css.borderBottomColor (Css.rgb 59 130 246) |> Css.important
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


toggle : Msg -> Bool -> Html Msg
toggle toggleMsg enabled =
    button
        [ Attr.type_ "button"
        , Events.onClick toggleMsg
        , css
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
        , attribute "aria-pressed" "false"
        ]
        [ span
            [ css
                [ Tw.sr_only
                ]
            ]
            [ text "Use setting" ]
        , span
            [ attribute "aria-hidden" "true"
            , css
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


footerView : Html msg
footerView =
    {- This example requires Tailwind CSS v2.0+ -}
    footer
        [ css
            [ Tw.bg_white
            , Tw.flex
            , Tw.justify_around
            ]
        ]
        [ div
            [ css
                [ Tw.max_w_7xl

                --, Tw.mx_auto
                , Tw.py_4
                , Tw.px_4

                --, Tw.justify_around
                --, Bp.lg
                --    [ Tw.py_16
                --    , Tw.px_8
                --    ]
                --, Bp.sm
                --    [ Tw.px_6
                --    ]
                ]
            ]
            [ div
                [ css
                    []
                ]
                [ div
                    [ css
                        [ Tw.space_x_8
                        , Tw.flex
                        , Tw.items_center
                        ]
                    ]
                    [ img
                        [ css
                            [ Tw.h_6
                            , Tw.w_6
                            ]
                        , Attr.src "https://res.cloudinary.com/dillonkearns/image/upload/v1614626535/Incremental_Elm_Logo_aeb8qs.png"
                        , Attr.alt "Incremental Elm"
                        , Attr.height 10
                        , Attr.width 10
                        ]
                        []
                    , p
                        [ css
                            [ Tw.text_gray_500
                            , Tw.text_base
                            ]
                        ]
                        [ text "Brought to you by Dillon Kearns. Check out more of my work at "
                        , a
                            [ Attr.href "https://incrementalelm.com"
                            , Attr.rel "noopener"
                            , Attr.target "_blank"
                            , css
                                [ Css.color (Css.rgb 0 54 249)
                                , Css.hover
                                    [ Tw.text_blue_700
                                    ]
                                ]
                            ]
                            [ text "incrementalelm.com" ]
                        , text "."
                        ]
                    , div
                        [ css
                            [ Tw.flex
                            , Tw.space_x_6
                            ]
                        ]
                        [ a
                            [ Attr.href "https://twitter.com/dillontkearns"
                            , Attr.rel "noopener"
                            , Attr.target "_blank"
                            , css
                                [ Tw.text_gray_400
                                , Css.hover
                                    [ Tw.text_gray_500
                                    ]
                                ]
                            ]
                            [ span
                                [ css
                                    [ Tw.sr_only
                                    ]
                                ]
                                [ text "Twitter" ]
                            , Svg.svg
                                [ SvgAttr.css
                                    [ Tw.h_6
                                    , Tw.w_6
                                    ]
                                , SvgAttr.fill "currentColor"
                                , SvgAttr.viewBox "0 0 24 24"
                                , attribute "aria-hidden" "true"
                                ]
                                [ Svg.path
                                    [ SvgAttr.d "M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84"
                                    ]
                                    []
                                ]
                            ]
                        , a
                            [ Attr.href "https://github.com/dillonkearns/"
                            , Attr.rel "noopener"
                            , Attr.target "_blank"
                            , css
                                [ Tw.text_gray_400
                                , Css.hover
                                    [ Tw.text_gray_500
                                    ]
                                ]
                            ]
                            [ span
                                [ css
                                    [ Tw.sr_only
                                    ]
                                ]
                                [ text "GitHub" ]
                            , Svg.svg
                                [ SvgAttr.css
                                    [ Tw.h_6
                                    , Tw.w_6
                                    ]
                                , SvgAttr.fill "currentColor"
                                , SvgAttr.viewBox "0 0 24 24"
                                , attribute "aria-hidden" "true"
                                ]
                                [ Svg.path
                                    [ SvgAttr.fillRule "evenodd"
                                    , SvgAttr.d "M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
                                    , SvgAttr.clipRule "evenodd"
                                    ]
                                    []
                                ]
                            ]
                        ]
                    ]
                , div
                    [ css
                        [--Tw.mt_12
                         --, Tw.grid
                         --, Tw.grid_cols_2
                         --, Tw.gap_8
                         --, Bp.xl
                         --    [ Tw.mt_0
                         --    , Tw.col_span_2
                         --    ]
                        ]
                    ]
                    []
                ]
            ]
        ]
