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
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw


port copyGeneratedCode : () -> Cmd msg


port saveConfig : String -> Cmd msg


type alias Model =
    { htmlInput : String
    , config : Config
    , showSettings : Bool
    }


init : Maybe String -> ( Model, Cmd msg )
init configJsonString =
    ( { htmlInput = """<a href="#" />"""
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
            , copyGeneratedCode ()
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
                    [ settingsPanel model ]
                , textarea
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
            , textarea
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
    main_
        [ css [ Tw.relative ] ]
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
