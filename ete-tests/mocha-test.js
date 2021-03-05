const { compileToStringSync } = require("node-elm-compiler");
const fs = require("fs");
const { exec } = require("child_process");
const path = require("path");
const { dir } = require("console");

async function run() {
  // console.log(testFiles());

  // testFiles().forEach(runExample);
  runExample("Example2");
}

async function runExample(name) {
  await runElm(fs.readFileSync(`./examples/${name}.html`).toString(), name);
  exec(
    `elm make ./examples/${name}.elm --output=/dev/null`,
    (error, stdout, stderr) => {
      console.log(stdout);
      console.log(stderr);
      if (error !== null) {
        // console.log(`exec error: ${error}`);
        process.exitCode = 1;
      }
    }
  );
}

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
          `examples/${name}.elm`,
          `module ${name} exposing (result)

import Html.Attributes as Attr
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (attribute, css)
import Svg.Styled exposing (path, svg)
import Svg.Styled.Attributes as SvgAttr
import Tailwind.Utilities as Tw
import Tailwind.Breakpoints as Bp


result =
    ${generatedElmHtmlCode}
`
        );
        delete Elm;
        resolve();
      });
      console.warn = warnOriginal;
    })();
  });
}

// run();

const assert = require("chai").assert;

describe("add()", function () {
  testFiles().forEach((name) => {
    it(name, async function () {
      // const res = add(args);

      // assert.equal(name, "name");

      await runElm(fs.readFileSync(`./examples/${name}.html`).toString(), name);
      exec(
        `elm make ./examples/${name}.elm --output=/dev/null`,
        (error, stdout, stderr) => {
          console.log(stdout);
          console.log(stderr);
          assert.isNull(error, "Unexpected Elm compilation error.");
          if (error !== null) {
            // console.log(`exec error: ${error}`);

            process.exitCode = 1;
          }
        }
      );
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
