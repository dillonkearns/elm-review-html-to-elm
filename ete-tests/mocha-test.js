const { compileToStringSync } = require("node-elm-compiler");
const fs = require("fs");
const { execSync } = require("child_process");
const path = require("path");
const { dir } = require("console");

function testFiles() {
  return fs
    .readdirSync(path.join(__dirname, "examples"), { withFileTypes: true })
    .filter(
      (dirent) => dirent.isFile() && path.extname(dirent.name) === ".html"
    )
    .map((dirent) => path.parse(dirent.name).name);
}

async function runElm(htmlInput, name) {
  return new Promise((resolve, reject) => {
    console.log("runElm", name);
    fs.writeFileSync(
      `Run${name}.elm`,
      `port module Run${name} exposing (main)

import ConfigHelpers as Config
import HtmlToTailwind exposing (htmlToElmTailwindModules)

htmlInputString : String
htmlInputString =
    """${htmlInput}
"""

result : String
result =
    htmlToElmTailwindModules Config.testConfig htmlInputString

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
    const data = compileToStringSync([`Run${name}.elm`], {});
    if (data === "") {
      throw "Compiler error";
    }

    (function () {
      const warnOriginal = console.warn;
      console.warn = function () {};

      eval(data.toString());
      const app = Elm[`Run${name}`].init();
      app.ports.toJs.subscribe((generatedElmHtmlCode) => {
        fs.writeFileSync(
          `examples/${name}.elm`,
          `module ${name} exposing (main)

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
${generatedElmHtmlCode}
`
        );
        resolve();
      });
      console.warn = warnOriginal;
    })();
  });
}

// run();

const assert = require("chai").assert;

describe("generated code is valid", function () {
  testFiles().forEach((name) => {
    it(name, async function () {
      process.chdir(__dirname);
      await runElm(fs.readFileSync(`./examples/${name}.html`).toString(), name);
      execSync(
        `elm make ./examples/${name}.elm --output=/dev/null`,
        (error, stdout, stderr) => {
          assert.isNull(error, "Unexpected Elm compilation error.");
        }
      );

      try {
        execSync(
          `git diff --exit-code examples/${name}.elm`,
          (error, stdout, stderr) => {
            assert.isNull(
              error,
              `The generated output changed. Restore the output format, or commit the changed file to approve it.\n\n${stdout}${stderr}`
            );
          }
        );
      } catch (error) {
        assert.fail(
          `The generated output changed. Restore the output format, or commit the changed file to approve it.\n\n${error.stdout}`
        );
      }
    });
  });
});

function testFiles() {
  return fs
    .readdirSync(path.join(__dirname, "examples"), { withFileTypes: true })
    .filter(
      (dirent) => dirent.isFile() && path.extname(dirent.name) === ".html"
    )
    .map((dirent) => path.parse(dirent.name).name);
}
