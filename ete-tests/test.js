#!/usr/bin/env node

const { compileToStringSync } = require("node-elm-compiler");
const fs = require("fs");

async function run() {
  runElm(fs.readFileSync("./examples/Example1.html").toString());
}

async function runElm(htmlInput) {
  fs.writeFileSync(
    "Run.elm",
    `port module Run exposing (main)

import HtmlToTailwind exposing (htmlToElmTailwindModules)

htmlInputString : String
htmlInputString =
    """${htmlInput}
"""

result : String
result =
    htmlToElmTailwindModules htmlInputString


port toJs : String -> Cmd msg


main : Program () () ()
main =
    Platform.worker
        { init = \\() -> ( (), toJs result )
        , update = \\msg model -> ( model, Cmd.none )
        , subscriptions = \\() -> Sub.none
        }
`
  );
  const data = compileToStringSync([`Run.elm`], {});
  if (data === "") {
    throw "Compiler error";
  }

  (function () {
    const warnOriginal = console.warn;
    console.warn = function () {};

    eval(data.toString());
    const app = Elm.Run.init();
    app.ports.toJs.subscribe((generatedElmHtmlCode) => {
      fs.writeFileSync(
        "examples/Example1.elm",
        `module Example1 exposing (result)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (attribute, css)
import Svg.Styled exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Utilities as Tw

result =
    ${generatedElmHtmlCode}
`
      );
    });
    console.warn = warnOriginal;
  })();
}

run();
