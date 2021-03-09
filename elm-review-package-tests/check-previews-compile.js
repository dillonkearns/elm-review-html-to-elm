#!/usr/bin/env node

const path = require('path');
const Ansi = require('./helpers/ansi');
const {execSync} = require('child_process');
const {findPreviewConfigurations} = require('./helpers/find-configurations');

const root = path.dirname(__dirname);

// Find all elm.json files

findPreviewConfigurations().forEach(checkThatExampleCompiles);

function checkThatExampleCompiles(exampleConfiguration) {
  try {
    execSync(`npx elm-review --config ${exampleConfiguration} --report=json`, {
      encoding: 'utf8',
      stdio: 'pipe',
      cwd: path.resolve(__dirname, '..')
    }).toString();
    success(exampleConfiguration);
  } catch (error) {
    try {
      const output = JSON.parse(error.stdout);
      // We don't care whether there were any reported errors.
      // If the root type is not "error", then the configuration compiled
      // successfully, which is all we care about in this test.
      if (output.type !== 'review-errors') {
        console.log(
          `${Ansi.red('✖')} ${Ansi.yellow(
            `${path.relative(root, exampleConfiguration)}/`
          )} does not compile.`
        );
        console.log(
          `Please run
    ${Ansi.yellow(`npx elm-review --config ${exampleConfiguration}/`)}
and make the necessary changes to make it compile.`
        );
        process.exit(1);
      }

      success(exampleConfiguration);
      return;
    } catch {
      console.log(
        `An error occurred while trying to check whether the ${Ansi.yellow(
          path.relative(root, exampleConfiguration)
        )} configuration compiles.`
      );
      console.error(error);
      process.exit(1);
    }
  }
}

function success(config) {
  console.log(`${Ansi.green('✔')} ${path.relative(root, config)}/ compiles`);
}
